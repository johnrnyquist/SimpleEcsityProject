import Ecsity
import SpriteKit

final class GameScene: SKScene {
    private(set) lazy var game = IntroToEcsity(scene: self)
    private(set) var previousTime: TimeInterval = 0
    private let launchHint = SKLabelNode(fontNamed: "HelveticaNeue")

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        isUserInteractionEnabled = true
        previousTime = CACurrentMediaTime()
        if game.engine.numEntities == 0 && launchHint.parent == nil {
            launchHint.text = "Tap to launch a ship.\nTap a ship to pause or resume."
            launchHint.numberOfLines = 2
            launchHint.fontSize = 20
            launchHint.verticalAlignmentMode = .center
            launchHint.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(launchHint)
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        launchHint.position = CGPoint(x: frame.midX, y: frame.midY)
    }

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - previousTime
        previousTime = currentTime
        game.engine.update(deltaTime: delta)
    }

    func touchDown(atPoint point: CGPoint) {
        if let ship = nodes(at: point).first(where: { $0.name == "ship" }) {
            toggleMovement(of: ship)
        } else {
            launchHint.removeFromParent()
            launchShip(at: point)
        }
    }

    private func launchShip(at point: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: "ship")
        sprite.name = "ship"
        let heading = Double.random(in: 0..<(2 * .pi))
        sprite.zRotation = CGFloat(heading)
        let speed = Double.random(in: 25...200)
        let ship = Ecsity.Entity()
        game.engine.add(component: Position(point: point), to: ship)
        game.engine.add(component: Velocity(dx: cos(heading) * speed, dy: sin(heading) * speed), to: ship)
        game.engine.add(component: Display(node: sprite), to: ship)
    }

    private func toggleMovement(of node: SKNode) {
        let engine = game.engine
        guard let ship = engine.findEntities(with: [Display.self]).first(where: {
            engine.find(componentType: Display.self, in: $0)?.node === node
        }) else { return }

        if let velocity = engine.find(componentType: Velocity.self, in: ship) {
            engine.add(component: PausedVelocity(velocity: velocity), to: ship)
            engine.remove(componentType: Velocity.self, from: ship)
        } else if let paused = engine.find(componentType: PausedVelocity.self, in: ship) {
            engine.add(component: paused.velocity, to: ship)
            engine.remove(componentType: PausedVelocity.self, from: ship)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            touchDown(atPoint: touch.location(in: self))
        }
    }
}
