import Foundation
import Ecsity

open class MovementSystem: System {
    private weak var engine: Engine?

    public init(engine: Engine) {
        self.engine = engine
    }

    public func update(time: TimeInterval) {
        guard let engine else { return }
        for entity in engine.findEntities(with: [Position.self, Velocity.self]) {
            guard var position = engine.find(componentType: Position.self, in: entity),
                  let velocity = engine.find(componentType: Velocity.self, in: entity) else { continue }
            position.x += velocity.dx * time
            position.y += velocity.dy * time
            engine.add(component: position, to: entity)
        }
    }
}
