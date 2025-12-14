import SwiftUI

struct WrapView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 8
    @ViewBuilder var content: (Data.Element) -> Content

    var body: some View {
        FlowLayout(spacing: spacing, lineSpacing: lineSpacing) {
            ForEach(Array(data), id: \.self, content: content)
        }
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat
    var lineSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(subviews: subviews, maxWidth: proposal.width ?? .infinity).size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let layoutData = layout(subviews: subviews, maxWidth: bounds.width)
        for (index, frame) in layoutData.frames.enumerated() where index < subviews.count {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.origin.x, y: bounds.minY + frame.origin.y),
                proposal: ProposedViewSize(width: frame.width, height: frame.height)
            )
        }
    }

    private func layout(subviews: Subviews, maxWidth: CGFloat) -> (size: CGSize, frames: [CGRect]) {
        var frames: [CGRect] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxLineWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            let exceedsRow = currentX > 0 && currentX + size.width > maxWidth
            if exceedsRow {
                currentX = 0
                currentY += rowHeight + lineSpacing
                rowHeight = 0
            }

            let origin = CGPoint(x: currentX, y: currentY)
            frames.append(CGRect(origin: origin, size: size))

            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxLineWidth = max(maxLineWidth, currentX - spacing)
        }

        let totalHeight = currentY + rowHeight
        return (
            CGSize(width: min(maxWidth, maxLineWidth), height: totalHeight),
            frames
        )
    }
}
