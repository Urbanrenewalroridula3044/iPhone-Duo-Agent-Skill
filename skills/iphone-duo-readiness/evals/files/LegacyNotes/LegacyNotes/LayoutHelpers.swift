import UIKit

enum LayoutHelpers {
    /// Width of a note card: 90% of the screen on phones, a fixed column on iPad.
    static func cardWidth() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600
        }
        return UIScreen.main.bounds.width * 0.9
    }

    static func hairline() -> CGFloat {
        1 / UIScreen.main.scale
    }

    static var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
}
