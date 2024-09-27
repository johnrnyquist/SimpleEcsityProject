import Ecsity
import SpriteKit


class IntroToEcsity {

	var scene: GameScene
	var engine: Engine!


	init(scene: GameScene, width: Double, height: Double) {

		// our container is an SKScene, we use it to render things to
		self.scene = scene

		engine = Engine()

		// add some systems to the engine

        engine.add(system: MovementSystem(engine: engine))
        engine.add(system: DisplaySystem(engine: engine, scene: scene))

	}
    
}
