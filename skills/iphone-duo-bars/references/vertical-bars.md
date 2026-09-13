# Vertical bars — code

Samples from Tech Talk 111462 as published on the session page. APIs marked
**27.1** were absent from the iOS 27.0 SDK; confirm with `scripts/sdk_api_check.py`.

## Opt in: use container bars (2:24, 2:39)

```swift
// SwiftUI — toolbar inside a navigation container
var body: some View {
    NavigationStack {
        ContentView()
            .toolbar {
                ToolbarItem(placement: .bottomBar) { /* ... */ }
            }
    }
}
```

```swift
// UIKit — content of standalone bars is not considered
let toolbar = UIToolbar()          // ✗ not part of the vertical bar
toolbar.items = [/* ... */]

// ✓ let the navigation controller own the toolbar
toolbarItems = [/* ... */]
navigationController?.setToolbarHidden(false, animated: false)
```

## Back or close at the top (5:00)

```swift
// SwiftUI
.toolbar {
    ToolbarItem(placement: .cancellationAction) { /* close */ }
}

// UIKit
navigationItem.leftItemsSupplementBackButton = false
navigationItem.leadingItemGroups = [UIBarButtonItemGroup(/* ... */)]
```

## Prominent actions next (5:24)

```swift
// SwiftUI
.toolbar {
    ToolbarItem(placement: .topBarPinnedTrailing) { /* done */ }
}

// UIKit
navigationItem.pinnedTrailingGroup = UIBarButtonItemGroup(/* ... */)
```

## Axis behavior — 27.1 (8:08, 8:36, 8:52)

```swift
// A custom view that has a vertical representation
ToolbarItem { ProfileView() }
    .axisBehavior(.verticalPreferred)

let item = UIBarButtonItem(customView: ProfileView())
item.axisBehavior = .verticalPreferred

// An item that switches between symbol and text: keep it horizontal
ToolbarItem { SelectOrDoneButton() }
    .axisBehavior(.horizontalOnly)

item.axisBehavior = .horizontalOnly
```

## Badges instead of text (9:27)

```swift
// SwiftUI
ToolbarItem(/* ... */) {
    InboxButton()
        .badge(7)
}

// UIKit (iOS 26)
let item = UIBarButtonItem(/* ... */)
item.badge = .count(7)
```

## Read the vertical bar edge — 27.1 (10:36)

```swift
// SwiftUI
struct ContentView: View {
    @Environment(\.toolbarVerticalEdge) var edge
    var body: some View {
        switch edge {
        // ...
        }
    }
}

// UIKit
switch traitCollection.verticalBarEdge {
// ...
}
```

## Compression — 27.1 (12:23)

```swift
// SwiftUI — keep toolbar items, compress the tab bar
TabView {
    Tab("Recents", systemImage: "clock") {
        ContentView()
            .toolbarVerticalCompressionBehavior(.prefersToolbarItems)
    }
}

// UIKit
navigationItem.verticalBarCompressionBehavior = .prefersBarItems
```

## One overflow menu (12:43)

```swift
// SwiftUI
.toolbar {
    ToolbarOverflowMenu {
        Button("Scan") { /* ... */ }
        Button("Connect") { /* ... */ }
    }
}

// UIKit
navigationItem.additionalOverflowItems = UIDeferredMenuElement({ provider in
    provider(self.persistentOverflowItems())
})
```

## Visibility priority (13:21)

```swift
// SwiftUI
.toolbar {
    ToolbarItem { Button(/* ... */) { /* ... */ } }
        .visibilityPriority(.high)
}

// UIKit
let item = UIBarButtonItem(/* ... */)
item.visibilityPriority = .high
```

## Opt out — 27.1 (14:47)

```swift
// SwiftUI
NavigationStack {
    ContentView()
        .toolbarVerticalBehavior(.disabled)
}

// UIKit
class MyViewController: UIViewController {
    override var preferredVerticalBarBehavior: UIVerticalBarBehavior { .disabled }
}
```

## Deployment targets below 27.1

A modifier introduced in 27.1 cannot be applied unconditionally when the app deploys
to an earlier iOS. Wrap it once and reuse:

```swift
extension ToolbarContent {
    @ToolbarContentBuilder
    func duoHorizontalOnly() -> some ToolbarContent {
        if #available(iOS 27.1, *) {
            self.axisBehavior(.horizontalOnly)
        } else {
            self
        }
    }
}
```

The builder shape was typechecked on the iOS 27.0 SDK with `visibilityPriority`
(an iOS 27.0 modifier) standing in, at an iOS 18 deployment target. With
`axisBehavior` it only compiles on an SDK that declares it.
