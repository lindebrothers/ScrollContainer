# ScrollContainer

This package provides a adjustable and scrollable SwiftUI view on top over another view. It uses the UIScrollViewDelegate via the [Introspect](https://github.com/siteline/SwiftUI-Introspect) package to recognize the gestures since the SwiftUI API does not yet provide these methods.

[ScrollContainer](https://github.com/lindebrothers/ScrollContainer/tree/main/ScrollContainerExample/ScrollContainer.git)!

Install this package with SPM

``` Swift: 
dependencies: [
    .package(url: "https://github.com/lindebrothers/ScrollContainer.git", .upToNextMajor(from: "1.0.0"))
]
```

Simple usage:
```
import ScrollContainer
import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollContainerWrapper(
            foregroundContent: {
            ForEach(0 ..< 100) { index in
                Text("\(index)")
            }
        }) {
            Color.blue
        }
    }
}
```

If you prefer to control the observable object you can just implement the `ScrollContainer` yourself. This is handy if you use a Redux pattern in your SwiftUI project.

``` Swift
import ScrollContainer
import SwiftUI

class MyModel: ScrollContainerObservable, ObservableObject {
    @Published private(set) var height: CGFloat = .zero

    private(set) var anchors: [CGFloat] = []
    private(set) var scrollEnabled: Bool = true
    private(set) var resizeable: Bool = true

    func setNewHeight(_ height: CGFloat) {
        self.height = height
    }

    func setNewAnchors(_ anchors: [CGFloat]) {
        self.anchors = anchors
    }
}

struct MyView: View {
    let model: MyModel
    let coordinator: ScrollContainerCoordinator
    init() {
        let model = MyModel()
        coordinator = ScrollContainerCoordinator(model: model, onNewHeight: { newHeight in
            model.setNewHeight(newHeight)
        },
        onNewAnchors: { anchors in
            model.setNewAnchors(anchors)
        })
        self.model = model
    }

    public var body: some View {
        ZStack {
           Color.blue
            ScrollContainerView(
                coordinator: coordinator,
                model: model
            ) {
                ForEach(0 ..< 100) { index in
                    Text("\(index)")
                }
            }
        }
    }
}
```

