import UIKit

import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView

    let style: UIBlurEffect.Style

    init(darkMode: Bool) {
        let style: UIBlurEffect.Style = darkMode ? .systemThinMaterialDark : .systemChromeMaterialLight
        self.style = style
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

internal extension Array where Element: Comparable & SignedNumeric {
    func nearest(to value: Element) -> (offset: Int, element: Element)? {
        enumerated().min(by: {
            abs($0.element - value) < abs($1.element - value)
        })
    }
}
