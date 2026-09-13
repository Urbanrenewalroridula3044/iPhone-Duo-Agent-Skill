import SwiftUI

struct InboxScreen: View {
    @State private var isSelecting = false
    @State private var unreadCount = 12
    @State private var isShowingFilters = false

    var body: some View {
        NavigationStack {
            List(0..<50) { index in
                Text("Message \(index)")
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit") {}
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isSelecting ? "Done" : "Select") {
                        isSelecting.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Unread only") {}
                        Button("Flagged") {}
                        Button("Attachments") {}
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("\(unreadCount) new")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}
