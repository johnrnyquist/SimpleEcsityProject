import Ecsity

struct Velocity: Component {
    var dx: Double
    var dy: Double
}

struct PausedVelocity: Component {
    let velocity: Velocity
}
