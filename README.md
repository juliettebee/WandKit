# 🪄  WandKit
WandKit, a library to easily interact with the Kano wand.
## How to
In your app's delegate or UIViewController add
```swift
import WandKit
// Some function
_ = Wand.shared
```
That creates a shared Wand object and connects to the wand.
To get info from a wand extend and subclass WandDelegate
```swift
extension ViewController : WandDelegate {
    func deviceFound () {
        print("Found device!")
    }
    
    func connected () {
        print("Connected to wand!")
    }

    func failToConnect () {
        print("Failed to connect")
    }

    func disconnect () {
        print("Wand disconnected")
    }

    // This gets called whenever the wand sends us its location
    // The Point struct is just x & y as UInt8
    func location (_ point: Point) {
        print("Wand is at \(point)")
    }

    // Called whenever the button on the wand is pressed
    func buttonPress () {
        print("Button pressed!")
    }
}
```
