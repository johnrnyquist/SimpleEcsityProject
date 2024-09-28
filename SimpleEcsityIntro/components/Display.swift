import SpriteKit
import Ecsity

open class Display: Component, Hashable, Equatable {
    public var node: SKNode

    public init(node: SKNode) {
        self.node = node
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func ==(lhs: Display, rhs: Display) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
