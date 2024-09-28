import Foundation
import Ecsity

class DisplaySystem: System {
    let engine: Engine
    let scene: GameScene

    init(engine: Engine, scene: GameScene) {
        self.engine = engine
        self.scene = scene
    }

    func update(time time: TimeInterval) {
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
