import SpriteKit
import XCTest
@testable import SimpleEcsityIntro

@MainActor
final class ShipMovementTests: XCTestCase {
    func testDismissedSceneAndItsEngineAreReleased() {
        weak var releasedScene: GameScene?
        weak var releasedEngine: AnyObject?
        autoreleasepool {
            let scene = GameScene(size: CGSize(width: 800, height: 600))
            scene.didMove(to: SKView())
            releasedScene = scene
            releasedEngine = scene.game.engine
        }
        XCTAssertNil(releasedScene)
        XCTAssertNil(releasedEngine)
    }

    func testMovementWritesPositionBackAndRendersItInTheSameFrame() throws {
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.didMove(to: SKView())
        let engine = scene.game.engine
        scene.touchDown(atPoint: CGPoint(x: 100, y: 100))
        let entity = try XCTUnwrap(engine.findEntities(with: [Position.self]).first)
        let initial = try XCTUnwrap(engine.find(componentType: Position.self, in: entity))
        engine.add(component: Velocity(dx: 3, dy: -4), to: entity)

        scene.update(scene.previousTime + 2)

        let current = try XCTUnwrap(engine.find(componentType: Position.self, in: entity))
        let display = try XCTUnwrap(engine.find(componentType: Display.self, in: entity))
        XCTAssertEqual(initial.point, CGPoint(x: 100, y: 100))
        XCTAssertEqual(current.point, CGPoint(x: 106, y: 92))
        XCTAssertEqual(display.node.position, current.point)
        XCTAssertTrue(display.node.parent === scene)
    }

    func testTappingShipPausesOnlyThatShipAndRestoresItsVelocityOnResume() throws {
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.didMove(to: SKView())
        let engine = scene.game.engine
        let start = CGPoint(x: 120, y: 100)
        scene.touchDown(atPoint: start)
        let ship = try XCTUnwrap(engine.findEntities(with: [Velocity.self]).first)
        let velocity = try XCTUnwrap(engine.find(componentType: Velocity.self, in: ship))
        let display = try XCTUnwrap(engine.find(componentType: Display.self, in: ship))
        let otherStart = CGPoint(x: 600, y: 500)
        scene.touchDown(atPoint: otherStart)
        engine.update(deltaTime: 0)
        let other = try XCTUnwrap(engine.findEntities(with: [Velocity.self]).first { $0 != ship })
        let otherDisplay = try XCTUnwrap(engine.find(componentType: Display.self, in: other))

        scene.touchDown(atPoint: start)
        engine.update(deltaTime: 0.25)

        XCTAssertNil(engine.find(componentType: Velocity.self, in: ship))
        XCTAssertEqual(engine.findEntities(with: [Position.self, Velocity.self]), [other])
        XCTAssertTrue(display.node.parent === scene)
        XCTAssertEqual(display.node.position, start)
        XCTAssertNotEqual(otherDisplay.node.position, otherStart)

        scene.touchDown(atPoint: start)
        let resumed = try XCTUnwrap(engine.find(componentType: Velocity.self, in: ship))
        XCTAssertEqual(resumed.dx, velocity.dx)
        XCTAssertEqual(resumed.dy, velocity.dy)
        engine.update(deltaTime: 0.25)
        XCTAssertNotEqual(display.node.position, start)
        XCTAssertEqual(engine.numEntities, 2)
    }
}
