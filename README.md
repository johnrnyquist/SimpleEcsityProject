# Ecsity SpriteKit example

Tap empty space to launch a ship. Tap a moving ship to stop it, then tap it again to resume at its original speed and heading. Each ship responds independently.

## Run the example

Place the [Ecsity package](https://github.com/johnrnyquist/Ecsity) in a folder named `Ecsity` next to this repository. Use the package revision recorded in the Xcode project's `Package.resolved`.

Open `SimpleEcsityIntro.xcworkspace` in Xcode to use the sibling package. Select the `SimpleEcsityIntro` scheme and an iOS simulator, then press ⌘R to run or ⌘U to run the tests. Opening the standalone `.xcodeproj` uses the pinned revision from GitHub.

## How a frame works

1. Adding a `Position` registers the ship's entity. The scene then adds a `Display` holding its SpriteKit node and a `Velocity` in points per second.
2. `MovementSystem` finds entities with both `Position` and `Velocity`. It advances the position by velocity times elapsed seconds and writes the updated struct back with `engine.add(component:to:)`.
3. `DisplaySystem` runs next. It finds entities with `Position` and `Display` and places each node at its stored position.
4. Tapping a moving ship saves its velocity in `PausedVelocity` and removes `Velocity`. The ship leaves the movement query and stays in the display query. A second tap restores the saved velocity and the movement system picks it up on the next frame.
