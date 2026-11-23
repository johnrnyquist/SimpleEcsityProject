# Ecsity SpriteKit example

Launch two ships and pause one while the other keeps flying. This small Swift game uses Ecsity to track each ship’s movement and SpriteKit to draw it.

## Run the example

```sh
git clone https://github.com/johnrnyquist/SimpleEcsityProject.git
cd SimpleEcsityProject
open SimpleEcsityIntro.xcodeproj
```

Xcode resolves the Ecsity package from GitHub. Select the `SimpleEcsityIntro` scheme and an iPhone simulator running iOS 17 or later. Press **⌘R** to run or **⌘U** to run the tests.

## Try it

1. The scene starts empty. Tap near the center to launch a ship, then tap the ship to pause it. In Simulator, a click counts as a tap.
2. Tap empty space to launch a second ship. It moves while the first stays in place.
3. Tap the paused ship again. It resumes at its original speed and heading.

## Follow a ship through the code

A tap on empty space creates an entity. Adding `Position` registers it with the engine. `Display` holds its SpriteKit node, and `Velocity` gives its horizontal and vertical speed in points per second. [GameScene.swift](SimpleEcsityIntro/GameScene.swift)

Each frame, the engine runs these systems in order. [IntroToEcsity.swift](SimpleEcsityIntro/IntroToEcsity.swift)

| System | Required components | What it does |
| --- | --- | --- |
| [`MovementSystem`](SimpleEcsityIntro/systems/MovementSystem.swift) | `Position`, `Velocity` | Advances the position by velocity times elapsed seconds and writes the updated `Position` struct back to the engine. |
| [`DisplaySystem`](SimpleEcsityIntro/systems/DisplaySystem.swift) | `Position`, `Display` | Places the sprite at the entity’s current position. |

Pausing a ship saves its velocity in `PausedVelocity` and removes `Velocity`. The ship still has `Position` and `Display`, so it stays visible. Restoring the saved velocity lets `MovementSystem` move it again. [GameScene.swift](SimpleEcsityIntro/GameScene.swift)

## Develop with a local Ecsity checkout

To edit Ecsity alongside the example, clone the package into a folder named `Ecsity` beside `SimpleEcsityProject`. Open `SimpleEcsityIntro.xcworkspace` to use that checkout. [Ecsity repository](https://github.com/johnrnyquist/Ecsity)
