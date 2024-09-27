import Foundation
import Ecsity

class DisplaySystem: System {
    let engine: Engine
    let scene: GameScene

    init(engine: Engine, scene: GameScene) {
        self.engine = engine
        self.scene = scene
    }

    func update(time deltaTime: TimeInterval) {
        for entity in engine.findEntities(with: [Display.self, Position.self]) {
            guard let display = engine.find(componentType: Display.self, in: entity),
                  let position = engine.find(componentType: Position.self, in: entity)
            else { continue }
            if display.node.parent == nil { scene.addChild(display.node) }
            display.node.position.x = position.x
            display.node.position.y = position.y
        }
    }
}

import Foundation
import Ecsity

open class MovementSystem: System {
    weak var engine: Engine!

    public init(engine: Engine) {
        self.engine = engine
    }

    public func update(time: TimeInterval) {
        let entities = engine.findEntities(with: [Position.self, Velocity.self])
        for entity in entities {
            guard let position: Position = engine.find(componentType: Position.self, in: entity),
                  let velocity: Velocity = engine.find(componentType: Velocity.self, in: entity) else {
                continue
            }
            // If position were value type, copy it via assignment and change to var
            let newPosition = position
            newPosition.x += velocity.dx * time
            newPosition.y += velocity.dy * time
            // Then update the position in the entity only if it has changed in the storage, not necessary for classes
            if newPosition != position {
                engine.add(component: newPosition, to: entity)
            }
        }
    }
}
// If we were only dealing with classes, the below would work.
// However, we are dealing with structs, so we need to update the component in the archetypeStorage.
//        for entity in archetype.entities {
//            if let velocity = archetype.find(componentType: Velocity.self, in: entity),
//               let position = archetype.find(componentType: Position.self, in: entity) {
//                position.x += velocity.dx
//                position.y += velocity.dy
//                // Mutating `position` directly within the archetype
//            }
//        }



import Foundation
import Ecsity

public class Position: Component, CustomStringConvertible, Equatable {
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

    public static func ==(lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public struct Velocity: Component {
    public var dx: Double
    public var dy: Double

    public init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
}

import SpriteKit

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
