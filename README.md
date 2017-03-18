<h1 align="left">fishPaint</h1>

<p align="left">
    <img src="https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat" alt="Platform: iOS 8+"/> <img src="https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat" alt="Xcode: 8.0+"/>
    <a href="https://developer.apple.com/swift">
    <img src="https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/fishPaint">
    <img src="https://img.shields.io/cocoapods/v/fishPaint.svg?style=flat" alt="CocoaPods compatible" /></a>
<br><br>
</p>

## Overview

FishPaint is a lightweight framework that offers a paint view for user written in Swift. FishPaint is built by using Core Gaphics.

## Requirements
* iOS 8.0+
* Xcode 8.0+
* Swift 3.0

## Installation

### Cocoapods:

FishPaint is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "fishPaint"
```

### Manual Installation:

Simply copy the contents of the 'Class' folder into your project.

## Demo Screen Shot

<img src="https://raw.githubusercontent.com/Dingo203/fishPaint/master/fishPaintDemo.png" width = "300" height = "568"/>

## Usage

### Getting Started:

Simply create a fishPaintView and add it to your View Controller:

```swift
let paintView = fishPaintView(frame: self.view.frame)
self.view.addSubview(paintView)
```
    
By default, the view will automatically respond to touch gestures and begin drawing. The default line color is **black**.

### Customization properties:

You can customization the properties for the fishPaintView, like `drawingEnabled`,`lineWidth`,`lineOpacity`,`lineColor`:

```swift
paintView.drawingEnabled = false
paintView.lineWidth = CGFloat(12.0)
paintView.lineOpacity = CGFloat(1.0)
paintView.lineColor = UIColor.white
```

### Edit action:

FishPaint can let user to delete the last line segment. Simply call the `removeLastLine` function:

```swift
paintView.removeLastLine()
```

If you wish to clear the whole canvas, simply call the `clearCanvas` function:

```swift
drawView.clearCanvas()
```   
    
### Delegate

FishPaint offers delegate functions to response user's reaction with a fishPaintView. To access these delegate methods, simply add your View Controller as the `fishPaintViewDelegate `:

```swift
class ViewController: UIViewController, fishPaintViewDelegate
```
    
There are four optional delegate methods:

```swift
func fishPaintDidBeginDrawing(view: fishPaintView)
    
func fishPaintIsDrawing(view: fishPaintView)
    
func fishPaintDidFinishDrawing(view: fishPaintView)
    
func fishPaintDidCancelDrawing(view: fishPaintView)
```

 
## License

FishPaint is available under the MIT license. See the LICENSE file for more info.


