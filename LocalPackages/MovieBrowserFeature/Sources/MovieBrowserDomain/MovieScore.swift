public struct MovieScore: Equatable, Hashable {
    public let value: Int?

    public init(value: Int?) {
        self.value = value
    }

    public var imdbText: String {
        guard let value else { return "NR" }
        let rating = Double(value) / 10.0
        if rating.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(rating))/10 IMDb"
        }
        return String(format: "%.1f/10 IMDb", rating)
    }
}
