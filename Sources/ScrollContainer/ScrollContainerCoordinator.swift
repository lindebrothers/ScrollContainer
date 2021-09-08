import SwiftUI

public class ScrollContainerCoordinator: NSObject, UIScrollViewDelegate {
    public init(
        model: ScrollContainerObservable,
        anchors: [CGFloat] = [UIScreen.main.bounds.height / 14 * 1, UIScreen.main.bounds.height / 12 * 3, UIScreen.main.bounds.height / 12 * 10],
        scrollEnabled: Bool = true,
        resizeable: Bool = true,
        onNewHeight: @escaping (CGFloat) -> Void,
        onNewAnchors: ((_ newAnchors: [CGFloat]) -> Void)? = nil
    ) {
        self.onNewHeight = onNewHeight
        self.onNewAnchors = onNewAnchors
        self.model = model

        // model = ScrollContainerModel(height: .zero, anchors: anchors, scrollEnabled: scrollEnabled, resizeable: resizeable)
    }

    private(set) var model: ScrollContainerObservable

    private var onNewHeight: (CGFloat) -> Void

    private var onNewAnchors: (([CGFloat]) -> Void)?
    
    public var scrollView: UIScrollView?

    private var heightAtStartDrag: CGFloat = .zero
    private var velocityY: CGFloat = .zero
    private var isResizing = false
    private var gestureIsActive = false
    private var isScrollingBelowZero: Bool = false

    private var isEndingDragging = false

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture: UIPanGestureRecognizer = scrollView.panGestureRecognizer

        let isScrollingBelowZero = (gesture.state != .possible && scrollView.contentOffset.y <= 0)

        let translationY = gesture.translation(in: scrollView).y

        // Dont scroll below zero during large state
        if gesture.state == .ended {
            gestureIsActive = false
        }

        if isEndingDragging {
            return disableScrolling(for: scrollView)
        }

        if let closestAnchor = model.anchors.nearest(to: model.height) {
            // Scroll for last index
            if closestAnchor.offset == model.anchors.count - 1 {
                if model.height <= model.anchors.last ?? 0, gestureIsActive && gesture.state != .possible && isScrollingBelowZero || isResizing {
                    isResizing = true
                    disableScrolling(for: scrollView)
                    if model.resizeable, scrollView.contentOffset.y <= 0 {
                        // model.height = heightAtStartDrag - translationY
                        onNewHeight(heightAtStartDrag - translationY)
                    }
                } else if !model.scrollEnabled {
                    disableScrolling(for: scrollView)
                } else {
                    scrollView.showsVerticalScrollIndicator = true
                }
            } else {
                // the rest
                disableScrolling(for: scrollView)

                if gestureIsActive {
                    isResizing = true
                    if model.resizeable {
                        onNewHeight(heightAtStartDrag - translationY)
                        // model.height = heightAtStartDrag - translationY
                    }
                }
            }
        }
    }

    public func disableScrolling(for scrollView: UIScrollView) {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = model.height + (model.height * velocityY / 1)
        if model.resizeable, scrollView.contentOffset.y <= 0, let closestAnchor = model.anchors.nearest(to: offset) {
            // model.height = model.anchors[closestAnchor.offset]
            onNewHeight(model.anchors[closestAnchor.offset])
            if model.height == model.anchors.last {
                isEndingDragging = true
            }
        }

        isResizing = false
    }

    // called when scroll view grinds to a halt
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isEndingDragging {
            disableScrolling(for: scrollView)
            isEndingDragging = false
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        velocityY = velocity.y
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        heightAtStartDrag = model.height
        gestureIsActive = true
        isEndingDragging = false
    }
}


// Other Public functions
internal extension ScrollContainerCoordinator {
    func scrollToZero(animated: Bool = true) {
        scrollView?.setContentOffset(.zero, animated: true)
    }

    func updateHeight(_ newHeight: CGFloat) {
        // model.height = newHeight
        onNewHeight(newHeight)
    }

    func updateAnchors(_ anchors: [CGFloat]) {
        onNewAnchors?(anchors)
    }
}
