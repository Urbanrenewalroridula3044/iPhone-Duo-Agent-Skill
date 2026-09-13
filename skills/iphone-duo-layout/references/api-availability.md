# API availability

The iPhone Duo talks target **Xcode 27.1 and the iOS 27.1 SDK**. Several APIs they
show do not exist in earlier SDKs, and at least one code sample does not match the
SDK spelling. Before writing code against any API from a talk:

```bash
python3 scripts/sdk_api_check.py                     # default iPhone Duo symbol list
python3 scripts/sdk_api_check.py --symbol axisBehavior --symbol reservedRegions
python3 scripts/sdk_api_check.py --format json       # includes declaration line and availability
```

The script reads the selected SDK's public headers and Swift interfaces (the files
the compiler uses) and reports which symbols exist. It changes nothing.

## Rules

1. **The SDK is the ground truth.** A talk's code sample is a snapshot. If the
   sample and the SDK disagree, write what the SDK declares and tell the developer
   about the mismatch.
2. **A symbol missing from the SDK does not compile**, and `if #available` cannot
   rescue it — availability checks need the declaration to exist. Do not write
   such code. Record the item in the plan as *blocked on Xcode 27.1* (or whichever
   SDK first declares it) and move on.
   Hiding guessed calls behind `#if compiler(>=…)`, `#if canImport` or a custom flag
   is the same mistake in disguise: nobody can compile or test that branch today, so it
   ships as unverified code whose signature may not match the real SDK. Offer the
   blocked item as a plan entry instead.
3. **Say which toolchain you checked.** Report `xcodebuild -version` and the SDK
   version next to any availability claim.
4. **Deployment target still matters.** A symbol present in the SDK but introduced
   in iOS 27.1 needs `if #available(iOS 27.1, *)` (SwiftUI modifiers: an
   availability-gated `ViewModifier`) when the deployment target is lower.

## Measured snapshot

Checked on **Xcode 27.0 beta 6 (27A5252f), iPhoneOS 27.0 SDK**. Re-run the script;
this table ages.

| Area | Present in 27.0 SDK | Absent from 27.0 SDK (announced for 27.1) |
| --- | --- | --- |
| Adaptivity | `effectiveGeometry`, `registerForTraitChanges`, `deviceMotionBody`, `headingBody` | — |
| Corners | `ConcentricRectangle`, `UICornerConfiguration` | — |
| Navigation | `defaultTabBarPlacement`, `prominentTabIdentifier`, `navigationBarMinimization`, `toolbarMinimizationBehavior`, `preferredImageVisibility` | `barMinimizationBehavior` (see below) |
| Bars | `topBarPinnedTrailing`, `pinnedTrailingGroup`, `leftItemsSupplementBackButton`, `additionalOverflowItems`, `ToolbarOverflowMenu`, `visibilityPriority` | `axisBehavior`, `toolbarVerticalEdge`, `verticalBarEdge`, `toolbarVerticalCompressionBehavior`, `verticalBarCompressionBehavior`, `toolbarVerticalBehavior`, `preferredVerticalBarBehavior` |
| Layout | — | `reservedRegions`, `ReservedRegion`, `UIViewReservedRegion`, `ArrangementView`, `arrangementViewStyle`, `UIArrangementViewController`, `overlayArrangementZIndex` |
| Displays | `sceneAccessory`, `onAvailabilityChange`, `UIWindowSceneActivationAction` (Swift: `UIWindowScene.ActivationAction`) | `onHingeChange`, `UIHingeInteraction`, `CameraCaptureAccessory` |

So with Xcode 27.0 you can already: remove legacy screen/orientation/idiom code,
adopt scene lifecycle, fix asymmetric safe-area math, move items into container
bars, give every item a title and symbol, set `visibilityPriority`, consolidate
overflow into `ToolbarOverflowMenu`, and place close/prominent items correctly.
Vertical-bar axis tuning, reserved regions, arrangements, the hinge and the camera
capture accessory wait for the 27.1 SDK.

## Known talk-versus-SDK mismatch

*Modernize your UIKit app* (11:30) shows:

```swift
navigationItem.barMinimizationBehavior = .always
navigationItem.barMinimizationSafeAreaAdjustment = .never
```

The iOS 27.0 SDK declares instead a `UIBarMinimization` configuration value:

```swift
// UIKit (iOS 27.0 SDK)
var minimization = navigationItem.navigationBarMinimization
minimization.minimizationBehavior = .onScrollDown   // .automatic, .never, .onScrollDown, .onScrollUp
minimization.safeAreaAdjustment = .disabled         // .automatic, .enabled, .disabled
navigationItem.navigationBarMinimization = minimization

// SwiftUI (iOS 27.0 SDK)
.toolbarMinimizationBehavior(_:for:)
.toolbarMinimizationSafeAreaAdjustment(_:for:)
```

There is no `.always` in that SDK. Verify against the SDK you build with before
using either spelling; a later SDK may differ again. The same caution applies to
every sample in `sources.md`.

## Swift spellings of Objective-C names

Talks and headers often use Objective-C class names. Swift may nest them:
`UIWindowSceneActivationAction` is `UIWindowScene.ActivationAction`, and
`UIWindowSceneActivationConfiguration` is `UIWindowScene.ActivationConfiguration` —
the flat names fail with "has been renamed". `sdk_api_check.py` searches both
headers and Swift interfaces, so a symbol can be *found* under its Objective-C name;
the compiler is the final word on the Swift spelling.

## Typechecked samples

The skills' code samples that use iOS 26/27.0 APIs were typechecked with
`xcrun --sdk iphonesimulator swiftc -typecheck` against the iOS 27.0 SDK: adaptivity
replacements, bar placements, badges, `visibilityPriority`, `ToolbarOverflowMenu`,
`additionalOverflowItems`, `navigationBarMinimization`, sidebar placement,
`prominentTabIdentifier`, safe-area insets, `ConcentricRectangle`, scene activation.
Samples using 27.1 APIs could not be checked and are reproduced from the session pages.
