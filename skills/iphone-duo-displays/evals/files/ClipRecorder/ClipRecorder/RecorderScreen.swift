import AVFoundation
import SwiftUI

@Observable
final class RecorderModel {
    let session = AVCaptureSession()
    var isRecording = false
    var script: [String] = [
        "Hi, and welcome back to the channel.",
        "Today we're looking at three ways to brew coffee.",
        "Let's start with the pour-over.",
    ]
    var currentLine = 0

    func start() {
        session.beginConfiguration()
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let input = try? AVCaptureDeviceInput(device: camera),
           session.canAddInput(input) {
            session.addInput(input)
        }
        session.commitConfiguration()
        Task.detached { [session] in session.startRunning() }
    }
}

struct RecorderScreen: View {
    @State private var model = RecorderModel()

    var body: some View {
        NavigationStack {
            CameraPreview(session: model.session)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    RecordButton(isRecording: $model.isRecording)
                        .padding(.bottom, 32)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Script", systemImage: "text.alignleft") {}
                    }
                }
                .task { model.start() }
        }
    }
}

struct RecordButton: View {
    @Binding var isRecording: Bool
    var body: some View {
        Button { isRecording.toggle() } label: {
            Circle().fill(isRecording ? .red : .white).frame(width: 72, height: 72)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    func updateUIView(_ uiView: PreviewView, context: Context) {}

    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
