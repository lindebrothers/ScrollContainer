import SwiftUI

public struct RoundedCorners: Shape {
    private var tl: CGFloat
    private var tr: CGFloat
    private var bl: CGFloat
    private var br: CGFloat

    public init(tl: CGFloat = 0.0, tr: CGFloat = 0.0, bl: CGFloat = 0.0, br: CGFloat = 0.0) {
        self.tl = tl
        self.tr = tr
        self.bl = bl
        self.br = br
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, height / 2), width / 2)
        let tl = min(min(self.tl, height / 2), width / 2)
        let bl = min(min(self.bl, height / 2), width / 2)
        let br = min(min(self.br, height / 2), width / 2)

        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - tr, y: 0))
        path.addArc(center: CGPoint(x: width - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: width, y: height - br))
        path.addArc(center: CGPoint(x: width - br, y: height - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: height))
        path.addArc(center: CGPoint(x: bl, y: height - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}
