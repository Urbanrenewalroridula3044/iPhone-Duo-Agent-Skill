# Sources

Every recommendation in these skills traces to one of the sessions below. Cite the
session and chapter timestamp when you recommend a change, so the developer can
watch the exact passage.

Chapter summaries and code samples are published on each session page. When a
code sample and the SDK disagree, the SDK wins — see `api-availability.md`.

## Prepare your app for iPhone Duo — Tech Talk 111461

<https://developer.apple.com/videos/play/tech-talks/111461/>

| Time | Chapter | Takeaway |
| --- | --- | --- |
| 0:30 | Build with the latest SDK | Apps run unmodified, but screen use improves per SDK: the iOS 27 SDK extends the app left of the status bar on the inner display; the iOS 27.1 SDK reaches the screen edge and lays standard navigation and toolbar buttons out vertically. |
| 1:17 | Get started in Xcode | Xcode 27.1, iPhone Duo simulator in Device Hub, on-screen controls to open, close, rotate and fold. |
| 1:33 | Adopt flexible layouts | No assumptions about display size or capability from the user interface idiom; design across a continuum of sizes. |
| 2:46 | Use size classes | Outer display behaves like other iPhones; inner display is regular × regular. The inner display does not honor supported interface orientations. |
| 3:57 | Avoid screen assumptions | Don't reference the main screen (ambiguous, being deprecated). Use environment, trait collection, scene bounds, `window?.windowScene?.screen`. Concentricity APIs fit the screen corners. |
| 5:01 | Adopt standard navigation | `NavigationSplitView`, `UISplitViewController`, `TabView`, `UITabBarController` adapt across every pose; sidebar placement on the inner display; sheets, popovers, context menus and alerts adapt. |
| 6:06 | Respect safe areas | Bars sit outside the safe area; interactive content inside it; backgrounds extend past it. Insets are often asymmetric — handle each side, test Split View. |
| 8:08 | Use reserved regions | iOS 27.1 `ReservedRegion` (SwiftUI) / `UIViewReservedRegion` (UIKit) let custom UI claim space without colliding with system UI. |
| 9:12 | Next steps | Xcode's app modernization skill is called App Resizability in Xcode 27.1 and covers SwiftUI and iPhone Duo. |

## Raise the bar with iPhone Duo — Tech Talk 111462

<https://developer.apple.com/videos/play/tech-talks/111462/>

| Time | Chapter | Takeaway |
| --- | --- | --- |
| 0:28 | Why bars move to the side | The wide aspect ratio moves top and bottom controls to the side; consistent on the inner display in landscape; horizontal again in portrait. |
| 2:00 | Opt in to vertical bars | Rebuild with the latest SDK and use container-provided bars. Custom `UIToolbar`/`UINavigationBar`/`UITabBar` content is not considered. |
| 3:09 | Shared bar region | Navigation, toolbar and tab bar share one region. In split views only the detail column participates; inspectors get no bar; sheets differ per display; the bar is hardware-aligned and does not flip for right-to-left. |
| 4:29 | Order items | Top: back or close (`.cancellationAction`; UIKit leading group with `leftItemsSupplementBackButton = false`), then prominent actions (`.topBarPinnedTrailing` / `pinnedTrailingGroup`). |
| 5:56 | Prepare toolbar content | Fixed width, flexible height. Items with an icon go vertical, text-only items stay horizontal. Always provide a title. |
| 8:00 | Control the axis | `axisBehavior(.verticalPreferred)` / `.horizontalOnly`; custom views stay horizontal by default. |
| 9:00 | Prefer symbol-only items | Use badges instead of text-plus-symbol; keep text that carries standalone information (a cart total) horizontal. |
| 10:07 | Adapt custom views | Fit the fixed width or adapt layout; read `toolbarVerticalEdge` / `verticalBarEdge`. No scroll edge effect by default; background with Reduce Transparency; flexible spacers are zero vertically. |
| 11:40 | Manage overflow | Overflow happens more on the outer display in landscape and with the keyboard. Toolbars compress first by default; `toolbarVerticalCompressionBehavior` / `verticalBarCompressionBehavior`. Consolidate into `ToolbarOverflowMenu` / `additionalOverflowItems`; the ellipsis is for overflow only. |
| 13:10 | Prioritize visibility | Items overflow bottom to top; `visibilityPriority` on groups first, then items. Frequent actions and badged status items overflow last. |
| 14:21 | When to opt out | Bottom-heavy single-page apps, single-control sheets: `toolbarVerticalBehavior(.disabled)` / `preferredVerticalBarBehavior`. |

## Strike a pose with adaptive layouts on iPhone Duo — Tech Talk 111463

<https://developer.apple.com/videos/play/tech-talks/111463/>

| Time | Chapter | Takeaway |
| --- | --- | --- |
| 0:27 | Reserved regions | Each display has its own size class; the hinge and cameras are reserved regions, treated like iPadOS window controls. |
| 1:29 | Designing around the hinge | Partially folded, the hinge divides the inner display; content spanning the fold is harder to see. |
| 2:26 | Displacement patterns | Adjust frames around reserved regions — independently or together; avoid excessive movement; continuously scrolling content does not displace. |
| 4:00 | Choose where content moves | Book pose: alerts to the trailing side. Tabletop: top region for viewing, bottom for interaction. |
| 5:12 | Adapt content | The system repositions action sheets, alerts, menus, popovers; split views split evenly; grids keep outer margins and widen spacing at the hinge. |
| 6:39 | Query reserved regions | `GeometryProxy.reservedRegions(kind:)` (GeometryReader or `onGeometryChange`), `UIView.reservedRegions(kind:)`; use `frame`. |
| 7:50 | Division and occlusion | Active vs inactive (`options: .includeInactive`); the fold is a division region, zero width when flat; occlusion regions represent the FaceTime camera. |
| 8:39 | System containers | Navigation containers and `List`/`ScrollView` adapt to the fold for free. |
| 9:20 | Arrangements | A layout container between navigation and content, arranging a primary and secondary view from size classes, aspect ratio and division regions. |
| 11:17 | ArrangementView | `ArrangementView { primary } secondary: { … }` inside `NavigationStack`; UIKit `UIArrangementViewController` as navigation root. |
| 12:00 | Split arrangement | `.arrangementViewStyle(.split)`; `.split.axes(.horizontal)`; a split that can't split shows one view; UIKit `updateArrangement(_:)`. |
| 13:21 | Overlay arrangement | `.overlay` stacks above or below, side by side when folded; `overlayArrangementZIndex` / `state(for:).zIndex`. |
| 14:39 | Choose | HStack/VStack → split, ZStack → overlay; foreground/background → overlay; main/detail → split. |
| 16:09 | When not to | No navigation containers inside an arrangement; no arrangement inside a scroll view or list. |

## Leverage multiple displays and scenes on iPhone Duo — Tech Talk 111464

<https://developer.apple.com/videos/play/tech-talks/111464/>

| Time | Chapter | Takeaway |
| --- | --- | --- |
| 0:49 | Respond to the hinge | `onHingeChange` (SwiftUI), `UIHingeInteraction` (UIKit): status closed / partially open / fully open, plus a continuous angle. |
| 1:18 | Drive an effect | Check for a non-nil hinge, filter `.partiallyOpen`, reset in the else branch. |
| 2:35 | Hinge data versus layout | Hinge data drives interactions and effects; layout uses arrangements and reserved regions. |
| 2:59 | Split view multitasking | All apps participate; a new video-plus-apps stacked layout; handle with size classes and scene geometry. |
| 3:38 | Multiple scenes | First iPhone with multiple app windows; none can be created on the outer display. Handle scene request errors; `UIWindowSceneActivationAction` hides itself when unavailable. |
| 4:22 | Scene accessories | Content on several displays at once; availability is system-controlled and can change any time. |
| 5:00 | Camera capture accessory | Outer-display UI while the main UI stays inside; requires full screen on the inner display with an active camera session; register on the camera view. |
| 5:34 | Teleprompter example | `.sceneAccessory { CameraCaptureAccessory(isEnabled:) { … } .onAvailabilityChange { … } }`, toolbar toggle disabled while unavailable. |

## Modernize your UIKit app — WWDC26 session 278

<https://developer.apple.com/videos/play/wwdc2026/278/>

| Time | Chapter | Takeaway |
| --- | --- | --- |
| 0:34 | App adaptivity | iPhone apps are fully resizable in iPhone Mirroring and on iPad. Audit scene lifecycle, main screen, idiom, orientation. |
| 2:10 | App lifecycle | UIScene lifecycle is required with the latest SDKs; without it the app no longer launches. |
| 2:51 | Main screen | Screen from the window scene; pass screens in; `traitCollection.displayScale`; automatic trait tracking; `registerForTraitChanges`; `effectiveGeometry` and `windowScene(_:didUpdateEffectiveGeometry:)`; view bounds. |
| 5:19 | Effective geometry (code sample) | `windowScene.effectiveGeometry` and `windowScene(_:didUpdateEffectiveGeometry:)` for scene-level available space; view bounds at 5:35. |
| 5:46 | Full-screen games | `UIRequiresFullScreen` is honored on iPhone in resizable environments from iOS 27, enabling discrete resizing. |
| 6:17 | Idiom | Not meaningful for layout; phone idiom apps are resizable on iPad. |
| 6:50 | Orientation | Supported orientations are a preference, ignored when resizable; iPhone Mirroring always reports portrait. |
| 7:55 | Body protocols | `UIView` conforms to Core Motion / Core Location body protocols: `deviceMotionBody`, `headingBody`. |
| 8:19 | Testing | Device Hub and Previews resize mode; real devices for iPhone Mirroring and iPad. |
| 9:18 | Tab bars and sidebars | `sidebar.preferredPlacement = .sidebar`, `sidebar.isAvailable`, `prominentTabIdentifier`. |
| 10:52 | Navigation bars | Bar minimization behavior; re-evaluate `.soft` scroll edge overrides. |
| 12:37 | Menus | `preferredImageVisibility`. |
| 14:07 | Agentic coding | Xcode's modernization skill; export with `xcrun agent skills export`. |

Related: *Get the most out of Device Hub* (WWDC26), *Build a great camera experience
for iPhone Duo* (Tech Talk), *Make your UIKit app more flexible* (WWDC25).
