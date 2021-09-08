import Introspect
import SwiftUI

public struct ScrollContainerWrapper<ForegroundContent: View, BackgroundContent: View>: View {
    public init(
        startHeight: CGFloat? = nil,
        anchors: [CGFloat]? = nil,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.8),
        @ViewBuilder foregroundContent: @escaping () -> ForegroundContent,
        @ViewBuilder backgroundContent: @escaping () -> BackgroundContent
    ) {
        self.foregroundContent = foregroundContent
        self.backgroundContent = backgroundContent
        self.startHeight = startHeight
        self.anchors = anchors
        self.animation = animation

        let model = DefaultModel()
        coordinator = ScrollContainerCoordinator(model: model, onNewHeight: { newHeight in
            model.setNewHeight(newHeight)
        },
        onNewAnchors: { anchors in
            model.setNewAnchors(anchors)
        })
        self.model = model
    }

    private var foregroundContent: () -> ForegroundContent
    private var backgroundContent: () -> BackgroundContent
    private var coordinator: ScrollContainerCoordinator
    private var model: DefaultModel
    private var startHeight: CGFloat?
    private var anchors: [CGFloat]?
    private var animation: Animation

    public var body: some View {
        ZStack {
            backgroundContent()
            ScrollContainerView(
                coordinator: coordinator,
                model: model,
                animation: animation,
                startHeight: startHeight,
                anchors: anchors,
                content: foregroundContent
            )
        }
    }
}

public struct ScrollContainerView<Content: View, Model: ObservableObject>: View where Model: ScrollContainerObservable {
    public init(
        coordinator: ScrollContainerCoordinator,
        model: Model,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.8),
        startHeight: CGFloat? = nil,
        anchors: [CGFloat]? = nil,
        content: @escaping () -> Content
    ) {
        self.animation = animation
        self.content = content
        self.coordinator = coordinator
        self.startHeight = startHeight
        self.model = model
    }

    private var startHeight: CGFloat?
    private var anchors: [CGFloat]?
    private var animation: Animation
    private var content: () -> Content
    private var coordinator: ScrollContainerCoordinator

    // Publics
    @ObservedObject var model: Model

    // Privates

    @Environment(\.colorScheme) private var colorScheme

    @State private var isPressed = false

    @State private var isDelegated = false

    public var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            Spacer()
                            RoundedCorners(tl: 10, tr: 10, bl: 10, br: 10)
                                .fill(Color.gray)
                                .frame(width: 36, height: 5)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(
                            backgroundView
                        )
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged { value in
                                self.isPressed = true
                                coordinator.updateHeight(UIScreen.main.bounds.size.height - value.location.y + 20)
                                coordinator.scrollToZero()
                            }
                            .onEnded { value in
                                self.isPressed = false
                                let newSize = geo.frame(in: .named("scrollContainer")).height - value.location.y + 20

                                if coordinator.model.resizeable, let closestAnchor = coordinator.model.anchors.nearest(to: newSize) {
                                    coordinator.updateHeight(coordinator.model.anchors[closestAnchor.offset])
                                    coordinator.scrollToZero()
                                }
                            }
                    )

                    VStack {
                        ScrollView {
                            VStack {
                                content()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }.introspectScrollView { scrollView in
                        if !isDelegated {
                            isDelegated = true

                            coordinator.updateAnchors(anchors ?? [
                                geo.frame(in: .local).height / 12 * 1,
                                geo.frame(in: .local).height / 12 * 4,
                                geo.frame(in: .local).height / 12 * 10,
                            ])
                            coordinator.updateHeight(startHeight ?? geo.frame(in: .local).height / 12 * 1)
                            coordinator.scrollView = scrollView
                            scrollView.delegate = coordinator
                        }
                    }

                    .background(backgroundView)
                }
                .frame(height: model.height)
                .animation(animation)
            }
            .frame(width: geo.frame(in: .local).width, height: geo.frame(in: .local).height, alignment: .top)
        }.coordinateSpace(name: "backgroundView")
    }

    @ViewBuilder private var backgroundView: some View {
        BlurView(darkMode: colorScheme == .dark)
    }
}
