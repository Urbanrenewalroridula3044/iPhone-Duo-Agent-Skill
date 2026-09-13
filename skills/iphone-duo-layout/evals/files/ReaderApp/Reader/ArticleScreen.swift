import SwiftUI

struct ArticleScreen: View {
    let article: Article
    @State private var isListening = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(article.title).font(.largeTitle.bold())
                    ForEach(article.paragraphs, id: \.self) { paragraph in
                        Text(paragraph).font(.body)
                    }
                }
                .padding()
                .frame(maxWidth: 430)
                .frame(maxWidth: .infinity)
            }

            Button {
                isListening.toggle()
            } label: {
                Label(isListening ? "Pause" : "Listen", systemImage: isListening ? "pause.fill" : "headphones")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.thinMaterial, in: Capsule())
            }
            .padding(.bottom, 24)
        }
        .navigationTitle(article.section)
    }
}

struct Article {
    let section: String
    let title: String
    let paragraphs: [String]
}
