import SwiftUI
import UIKit

/// Lets the docked mini player reach the glass at the end of the screen that has no cutout.
///
/// **This reads the interface orientation on purpose, and it is not a layout fork.**
/// In landscape iOS reports the same safe-area inset on both sides, whichever side the
/// Dynamic Island is physically on, so geometry alone cannot say which end is free.
/// The orientation answers that one physical question: `.landscapeLeft` puts the
/// cutout at the trailing end, `.landscapeRight` at the leading end. Nothing else
/// about the layout changes. Measured on iPhone 17 Pro: insets l62 r62 in both
/// landscape orientations.
struct DockBleedModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.leading, bleed(in: geometry).leading)
                .padding(.trailing, bleed(in: geometry).trailing)
        }
    }

    private func bleed(in geometry: GeometryProxy) -> (leading: CGFloat, trailing: CGFloat) {
        switch interfaceOrientation {
        case .landscapeLeft: (-geometry.safeAreaInsets.leading, 0)
        case .landscapeRight: (0, -geometry.safeAreaInsets.trailing)
        default: (0, 0)
        }
    }

    private var interfaceOrientation: UIInterfaceOrientation {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .interfaceOrientation ?? .portrait
    }
}
