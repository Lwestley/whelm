import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        return CGSize(
            width: proposal.width ?? 0,
            height: rows.last.map { $0.maxY } ?? 0
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: ProposedViewSize(bounds.size), subviews: subviews)
        for row in rows {
            for item in row.items {
                item.view.place(
                    at: CGPoint(x: bounds.minX + item.x, y: bounds.minY + item.y),
                    proposal: ProposedViewSize(item.size)
                )
            }
        }
    }

    private struct Row {
        var items: [(view: LayoutSubview, x: CGFloat, y: CGFloat, size: CGSize)]
        var maxY: CGFloat
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        let maxWidth = proposal.width ?? 0
        var rows: [Row] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowItems: [(view: LayoutSubview, x: CGFloat, y: CGFloat, size: CGSize)] = []
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && !rowItems.isEmpty {
                rows.append(Row(items: rowItems, maxY: y + rowHeight))
                y += rowHeight + spacing
                x = 0
                rowItems = []
                rowHeight = 0
            }
            rowItems.append((view: view, x: x, y: y, size: size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        if !rowItems.isEmpty {
            rows.append(Row(items: rowItems, maxY: y + rowHeight))
        }

        return rows
    }
}
