
import Foundation
import Ecsity

public struct Position: Component, CustomStringConvertible, Equatable {
    public var x: Double
    public var y: Double
    public var point: CGPoint {
        get {
            CGPoint(x: x, y: y)
        }
        set {
            x = Double(newValue.x)
            y = Double(newValue.y)
        }
    }

    public init(point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
    }

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public var description: String {
        "Position(x: \(x), y: \(y))"
    }
}
