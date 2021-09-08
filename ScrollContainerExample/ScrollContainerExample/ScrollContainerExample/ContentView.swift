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
