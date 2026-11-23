# Ecsity SpriteKit example

Launch two ships and pause one while the other keeps flying. This SpriteKit example shows how changing one component changes which systems work with a ship.

## Run the example

```sh
git clone https://github.com/johnrnyquist/SimpleEcsityProject.git
cd SimpleEcsityProject
open SimpleEcsityIntro.xcodeproj
```

Xcode resolves the Ecsity package from GitHub. Select the `SimpleEcsityIntro` scheme and an iPhone simulator running iOS 17 or later. Press **⌘R** to run or **⌘U** to run the tests.

1. Tap near the center to launch a ship. Tap the ship to pause it.
2. Tap empty space to launch a second ship. It moves while the first stays in place.
3. Tap the paused ship again. It resumes at its original speed and heading.

## Follow a ship through the code

In `GameScene.launchShip(at:)`, adding `Position` registers the new entity with the engine. The scene then adds `Velocity` in points per second and `Display` for the sprite. All three components are Swift structs. `Display` holds a reference to the SpriteKit node. [GameScene.swift](SimpleEcsityIntro/GameScene.swift) · [Display.swift](SimpleEcsityIntro/components/Display.swift)

Each frame, the scene passes elapsed time to the engine. Two systems run in the order the game added them. [IntroToEcsity.swift](SimpleEcsityIntro/IntroToEcsity.swift)

| System | Required components | What it does |
| --- | --- | --- |
| [`MovementSystem`](SimpleEcsityIntro/systems/MovementSystem.swift) | `Position`, `Velocity` | Advances the position by velocity times elapsed seconds and writes the updated struct back to the engine. |
| [`DisplaySystem`](SimpleEcsityIntro/systems/DisplaySystem.swift) | `Position`, `Display` | Adds the sprite to the scene if needed and places it at the updated position. |

Tapping a ship saves its velocity in `PausedVelocity` and removes `Velocity`. The ship now matches only `DisplaySystem`. Tapping it again restores `Velocity`, so both systems pick it up on the next frame. [GameScene.swift](SimpleEcsityIntro/GameScene.swift) · [Velocity.swift](SimpleEcsityIntro/components/Velocity.swift)

## Work on Ecsity alongside the example

Clone the Ecsity repository into a folder named `Ecsity` beside `SimpleEcsityProject`, then open `SimpleEcsityIntro.xcworkspace` to use that local checkout. [Ecsity repository](https://github.com/johnrnyquist/Ecsity)
