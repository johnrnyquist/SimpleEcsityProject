import SpriteKit
import Ecsity

class GameScene: SKScene {
    var game: IntroToEcsity!

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        game = IntroToEcsity(scene: self, width: frame.width, height: frame.height)
        previousTime = CACurrentMediaTime()
    }

    var previousTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - previousTime
        previousTime = currentTime
        game.engine.update(deltaTime: delta)
    }

    private func removeDisplayComponent(from node: SKNode) {
        game.engine.findEntities(with: [Display.self, Position.self, Velocity.self])
            .filter { game.engine.find(componentType: Display.self, in: $0)?.node == node }
            .forEach { game.engine.remove(componentType: Velocity.self, from: $0) }
    }

    func touchDown(atPoint pos: CGPoint, touch: UITouch) {
        let nodes = nodes(at: pos)
        if let node = nodes.first(where: { $0.name == "ship" }) {
            removeDisplayComponent(from: node)
            return
        }
        let position = Position(x: pos.x, y: pos.y)
        let sprite = SKSpriteNode(imageNamed: "ship")
        sprite.name = "ship"
        sprite.zRotation = CGFloat.random(in: 0...(2 * CGFloat.pi))
        let display = Display(node: sprite)
        let speed = Double.random(in: 25...200)
        let speedX = cos(Double(sprite.zRotation)) * speed
        let speedY = sin(Double(sprite.zRotation)) * speed
        let velocity = Velocity(dx: speedX, dy: speedY)
        let entity = Entity()
        game.engine.add(component: position, to: entity)
        game.engine.add(component: display, to: entity)
        game.engine.add(component: velocity, to: entity)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for t in touches {
            touchDown(atPoint: t.location(in: self), touch: t)
        }
    }

    override var isUserInteractionEnabled: Bool {
        get { true }
        set {}
    }
}
