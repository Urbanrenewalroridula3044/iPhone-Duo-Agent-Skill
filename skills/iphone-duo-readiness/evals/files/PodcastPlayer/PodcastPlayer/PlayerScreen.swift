import SwiftUI

struct PlayerScreen: View {
    @State private var isShowingUpNext = true

    var body: some View {
        HStack(spacing: 0) {
            PlayerView()
            if isShowingUpNext {
                UpNextView()
                    .frame(width: 320)
            }
        }
        .navigationTitle("Now Playing")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isShowingUpNext ? "Hide Queue" : "Show Queue") {
                    isShowingUpNext.toggle()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Sleep Timer") {}
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                } label: {
                    Label("AirPlay", systemImage: "airplayaudio")
                }
            }
        }
    }
}

struct PlayerView: View {
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 16).fill(.tint).aspectRatio(1, contentMode: .fit)
            Text("Episode 42").font(.title2)
            HStack(spacing: 40) {
                Image(systemName: "gobackward.15")
                Image(systemName: "play.fill").font(.largeTitle)
                Image(systemName: "goforward.30")
            }
        }
        .padding()
    }
}

struct UpNextView: View {
    var body: some View {
        List(1..<20) { index in
            Text("Episode \(42 + index)")
        }
    }
}
