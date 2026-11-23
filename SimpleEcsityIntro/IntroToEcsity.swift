import Ecsity

class IntroToEcsity {
    let engine = Engine()

    init(scene: GameScene) {
        engine.add(system: MovementSystem(engine: engine))
        engine.add(system: DisplaySystem(engine: engine, scene: scene))
    }
}
