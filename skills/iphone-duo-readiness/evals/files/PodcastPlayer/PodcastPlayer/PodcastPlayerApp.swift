import SwiftUI

@main
struct PodcastPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PlayerScreen()
            }
        }
    }
}
