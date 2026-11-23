import CoreGraphics
import Ecsity

struct Position: Component {
    var x: Double
    var y: Double

    var point: CGPoint {
        CGPoint(x: x, y: y)
    }

    init(point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
    }
}
