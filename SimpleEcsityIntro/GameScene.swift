import Ecsity
import SpriteKit

class GameScene: SKScene {
    var game: IntroToEcsity!

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        game = IntroToEcsity(scene: self)
        previousTime = CACurrentMediaTime()
    }

    var previousTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - previousTime
        previousTime = currentTime
        game.engine.update(deltaTime: delta)
    }

    private func toggleMovement(of node: SKNode) {
        let engine = game.engine
        guard let entity = engine.findEntities(with: [Display.self]).first(where: {
            engine.find(componentType: Display.self, in: $0)?.node === node
        }) else { return }

        if let velocity = engine.find(componentType: Velocity.self, in: entity) {
            engine.add(component: PausedVelocity(velocity: velocity), to: entity)
            engine.remove(componentType: Velocity.self, from: entity)
        } else if let paused = engine.find(componentType: PausedVelocity.self, in: entity) {
            engine.add(component: paused.velocity, to: entity)
            engine.remove(componentType: PausedVelocity.self, from: entity)
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        if let ship = nodes(at: pos).first(where: { $0.name == "ship" }) {
            toggleMovement(of: ship)
            return
        }
        let position = Position(point: pos)
        let sprite = SKSpriteNode(imageNamed: "ship")
        sprite.name = "ship"
        sprite.zRotation = CGFloat.random(in: 0...(2 * CGFloat.pi))
        let display = Display(node: sprite)
        let speed = Double.random(in: 25...200)
        let speedX = cos(Double(sprite.zRotation)) * speed
        let speedY = sin(Double(sprite.zRotation)) * speed
        let velocity = Velocity(dx: speedX, dy: speedY)
        let entity = Ecsity.Entity()
        game.engine.add(component: position, to: entity)
        game.engine.add(component: display, to: entity)
        game.engine.add(component: velocity, to: entity)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for t in touches {
            touchDown(atPoint: t.location(in: self))
        }
    }

    override var isUserInteractionEnabled: Bool {
        get { true }
        set {}
    }
}
