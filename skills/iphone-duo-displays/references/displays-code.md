# Displays, hinge and scenes — code

Samples as published on the session page of Tech Talk 111464. APIs marked **27.1**
were absent from the iOS 27.0 SDK; confirm with `scripts/sdk_api_check.py`.

## Hinge-driven effect — 27.1 (1:33–2:17)

```swift
struct InstrumentView: View {
    /// Normalized bend, 0 is no bend, 1 is deepest bend
    @State private var pitchBend: Double = 0

    var body: some View {
        GuitarView(pitchBend: pitchBend)
            .onHingeChange { _, context in
                // A nil hinge means the device doesn't have one
                if let hinge = context.hinge, hinge.status == .partiallyOpen {
                    pitchBend = calculatePitchBend(angle: hinge.angle)
                } else {
                    pitchBend = 0
                }
            }
    }

    private func calculatePitchBend(angle: Angle) -> Double { /* ... */ }
}
```

UIKit: add a `UIHingeInteraction` to the view; take its exact delegate or handler shape
from the SDK.

## Scene requests that can fail (3:38)

```swift
// ✗ silently fails on the outer display
UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity,
                                                   options: nil, errorHandler: nil)

// ✓ handle the failure
let request = UISceneSessionActivationRequest(role: .windowApplication, userActivity: activity)
UIApplication.shared.activateSceneSession(for: request) { error in
    // Tell the user, or fall back to opening the content in the current window.
}

// ✓ or let the action hide itself when new windows aren't available.
// Objective-C name: UIWindowSceneActivationAction; in Swift it is nested.
let newWindow = UIWindowScene.ActivationAction { _ in
    UIWindowScene.ActivationConfiguration(userActivity: activity)
}
```

## Camera capture accessory — 27.1 (5:43–6:25)

```swift
struct CameraRootView: View {
    @State private var model = TeleprompterModel()

    var body: some View {
        CameraView(model: model)
            .sceneAccessory {
                CameraCaptureAccessory(isEnabled: $model.isEnabled) {
                    TeleprompterView(model: model)
                }
                .onAvailabilityChange { newValue in
                    model.isAvailable = newValue
                }
            }
            .toolbar {
                TeleprompterToggle(isEnabled: $model.isEnabled)
                    .disabled(!model.isAvailable)
            }
    }
}
```

Requirements to state in the recommendation: the app is full screen on the inner
display, a camera session is active, and the accessory is registered on the camera
view itself.
