//
//  FlowLayout.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 21/06/26.
//

import SwiftUI

struct FlowLayout: Layout {

    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let maxWidth = proposal.width ?? 0

        var width: CGFloat = 0
        var height: CGFloat = 0

        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(.unspecified)

            if rowWidth + size.width > maxWidth {

                height += rowHeight + spacing
                rowWidth = size.width + spacing
                rowHeight = size.height

            } else {

                rowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }

            width = max(width, rowWidth)
        }

        height += rowHeight

        return CGSize(
            width: width,
            height: height
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > bounds.maxX {

                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
