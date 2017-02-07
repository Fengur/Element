![mit Status](https://img.shields.io/badge/License-MIT-brightgreen.svg) ![platform](https://img.shields.io/badge/Platform-macOS-blue.svg) ![Lang](https://img.shields.io/badge/Language-Swift 3.0.1-orange.svg) [![codebeat](https://codebeat.co/badges/2de7a2a5-91d5-401e-8913-8f1993affd55)](https://codebeat.co/projects/github-com-eonist-element) [![SPM  compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) [![Build Status](https://travis-ci.org/stylekit/Element-tests.svg?branch=master)](https://travis-ci.org/stylekit/Element-tests)

## Why programmatic UI?
The best use of your time/resources is to re-use code via frameworks. Importing Element in your app allows you add customizable GUI to your app. 

<img width="608" alt="img" src="https://raw.githubusercontent.com/stylekit/img/master/progressindicator2_trim.mp4.gif">

## How does it work?
A typical Element app consists of 90% Swift code and 10% CSS and SVG. CSS Handles design and alignment and swift handles functionality and animation.   

<img width="700" alt="img" src="https://dl.dropboxusercontent.com/u/2559476/Style_diagram.svg">

## Installation:
- Read  [This](http://stylekit.org/blog/2017/02/05/Xcode-and-spm/)  tutorial on how to start a new App project from Swift Package Manager
- Add this to your Package.swift file

```swift
import PackageDescription
let package = Package(
    name: "AwesomeApp",
    dependencies: [
		.Package(url: "https://github.com/eonist/Element.git", Version(0, 0, 0, prereleaseIdentifiers: ["alpha", "5"]))
    ]
)
```

- In AppDelegate.swift add this to the top ``@testable import Element`` and this inside the ``applicationDidFinishLaunching`` method:

```swift
StyleManager.addStyle("Button{fill:blue;}")
let btn = Button(100,20)
window.contentView!.addSubview(btn)
func onClick(event:Event){
	if(event.type == ButtonEvent.click){Swift.print("hello world")} 
}
btn.event = onClick
```

## Resources: 
Here is a simple example app made with Element: [Stash](https://github.com/stylekit/stash), here is a library of example code for each component that is available in Element: [Explorer](https://github.com/stylekit/explorer) and [here](https://github.com/stylekit/ElCapitan) are the macOS styles to get you started. 

## iOS:
Element for iOS coming soon [here](https://github.com/eonist/Element-iOS)   
<img width="186" alt="img" src="https://raw.githubusercontent.com/stylekit/img/master/switch8crop20fps.gif">  


## Need help?
Open an issue or message me on [twitter](https://twitter.com/stylekit_org) 