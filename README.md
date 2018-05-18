# SwiftVideoPlayer

[![CI Status](https://img.shields.io/travis/hapsidra/SwiftVideoPlayer.svg?style=flat)](https://travis-ci.org/hapsidra/SwiftVideoPlayer)
[![Version](https://img.shields.io/cocoapods/v/SwiftVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/SwiftVideoPlayer)
[![License](https://img.shields.io/cocoapods/l/SwiftVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/SwiftVideoPlayer)
[![Platform](https://img.shields.io/cocoapods/p/SwiftVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/SwiftVideoPlayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftVideoPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftVideoPlayer'
```

## Usage

```swift
let player = PlayerVC([(videoURL: URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!, previewURL: nil)])
self.present(player, animated: true, completion: nil)
```

or

```swift
class ViewController: PlayerVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

or

```swift
var player: PlayerVC!
override func viewDidLoad() {
    super.viewDidLoad()
    player = PlayerVC([(videoURL: URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!, previewURL: nil)])
    self.player.view.frame = CGRect(x: 50, y: 50, width: view.frame.width - 100, height: view.frame.height - 100)
    self.addChildViewController(player)
    self.view.addSubview(player.view)
    self.player.didMove(toParentViewController: self)
}
```

## Author

hapsidra, hapsidra@outlook.com

## License

SwiftVideoPlayer is available under the MIT license. See the LICENSE file for more info.
