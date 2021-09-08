import ScrollContainer
import SwiftUI

class Test: ScrollContainerObservable, ObservableObject {
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
