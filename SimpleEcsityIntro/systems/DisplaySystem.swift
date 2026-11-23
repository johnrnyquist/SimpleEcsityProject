import Foundation
import Ecsity

final class DisplaySystem: System {
    private weak var engine: Engine?
    private weak var scene: GameScene?

    init(engine: Engine, scene: GameScene) {
        self.engine = engine
        self.scene = scene
    }

    func update(time: TimeInterval) {
        guard let engine, let scene else { return }
        for entity in engine.findEntities(with: [Display.self, Position.self]) {
            guard let display = engine.find(componentType: Display.self, in: entity),
                  let position = engine.find(componentType: Position.self, in: entity) else { continue }
            if display.node.parent == nil {
                scene.addChild(display.node)
            }
            display.node.position = position.point
        }
    }
}
