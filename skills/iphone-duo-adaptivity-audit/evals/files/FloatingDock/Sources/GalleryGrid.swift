import SwiftUI
import UIKit

struct GalleryGrid: View {
    var body: some View {
        let columns = UIDevice.current.orientation.isLandscape ? 4 : 2
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
            ForEach(0..<40) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.3))
                    .frame(height: UIScreen.main.bounds.width / CGFloat(columns))
                    .overlay(Text("\(index)"))
            }
        }
    }
}
