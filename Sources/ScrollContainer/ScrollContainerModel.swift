import SwiftUI

public protocol ScrollContainerObservable {
    var height: CGFloat { get }
    var anchors: [CGFloat] { get }
    var scrollEnabled: Bool { get }
    var resizeable: Bool { get }
}

class DefaultModel: ScrollContainerObservable, ObservableObject {
    
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

open class ScrollContainerModel: ObservableObject {
    public init(height: CGFloat = .zero, anchors: [CGFloat] = [], scrollEnabled: Bool = true, resizeable: Bool = true) {
        self.height = height
        self.anchors = anchors
        self.scrollEnabled = scrollEnabled
        self.resizeable = resizeable
    }

    @Published public fileprivate(set) var height: CGFloat
    
    private(set) var anchors: [CGFloat]
    private(set) var scrollEnabled: Bool
    private(set) var resizeable: Bool
//
//    public func setHeight(_ height: CGFloat) {
//        self.height = height
//    }
//
//    public func setAnchors(_ anchors: [CGFloat]) {
//        self.anchors = anchors
//    }
//
//    public func setScrollEnabled(_ isEnabled: Bool) {
//        self.scrollEnabled = isEnabled
//    }
//    public func setResizable(_ isResizeable: Bool) {
//        self.resizeable = isResizeable
//    }
}


