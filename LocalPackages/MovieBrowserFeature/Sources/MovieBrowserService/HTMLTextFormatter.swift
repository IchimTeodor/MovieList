import Foundation

enum HTMLTextFormatter {
    static func plainText(from html: String?) -> String? {
        guard var html else { return nil }
        html = html.replacingOccurrences(
            of: "<br ?/?>",
            with: "\n",
            options: [.regularExpression, .caseInsensitive]
        )
        html = html.replacingOccurrences(
            of: "<[^>]+>",
            with: " ",
            options: [.regularExpression]
        )
        html = html.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )
        let decoded = decodeHTMLEntities(in: html)
        return decoded.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func decodeHTMLEntities(in string: String) -> String {
        var result = string
        let namedEntities: [String: String] = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#39;": "'",
            "&apos;": "'",
            "&nbsp;": " "
        ]
        for (entity, replacement) in namedEntities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }
        result = replaceNumericEntities(in: result, pattern: "&#(\\d+);", radix: 10)
        result = replaceNumericEntities(in: result, pattern: "&#x([0-9a-fA-F]+);", radix: 16)
        return result
    }

    private static func replaceNumericEntities(in string: String, pattern: String, radix: Int) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return string
        }
        var result = string
        let nsString = result as NSString
        let matches = regex.matches(in: result, options: [], range: NSRange(location: 0, length: nsString.length))
        for match in matches.reversed() {
            let valueRange = match.range(at: 1)
            let fullRange = match.range(at: 0)
            let valueString = nsString.substring(with: valueRange)
            guard let scalarValue = UInt32(valueString, radix: radix),
                  let scalar = UnicodeScalar(scalarValue) else {
                continue
            }
            let replacement = String(scalar)
            if let start = result.index(result.startIndex, offsetBy: fullRange.location, limitedBy: result.endIndex),
               let end = result.index(start, offsetBy: fullRange.length, limitedBy: result.endIndex) {
                result.replaceSubrange(start..<end, with: replacement)
            }
        }
        return result
    }
}
