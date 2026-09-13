import SwiftUI

struct LibraryScreen: View {
    let articles: [Article]

    var body: some View {
        NavigationStack {
            List(articles, id: \.title) { article in
                NavigationLink(article.title) {
                    ArticleScreen(article: article)
                }
            }
            .navigationTitle("Library")
        }
    }
}
