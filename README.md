# CPImageViewer

Viewing a single image using transition animation. Supporting presentation and push &  pop.

## Screenshot

##### Present & Dismiss

![](Screenshot1.gif)



##### Push & Pop

![](Screenshot2.gif)

## Installation

### Manually

The simplest way to install this library is to copy `Classes/*.swift` to your project.

### Carthage

```swift
github "cp3hnu/CPImageViewer"
```

* Drag and drop *CPImageViewer.framework* from /Carthage/Build/iOS/ to Linked frameworks and libraries in Xcode (Project>Target>General>Linked frameworks and libraries)

* Add new run script

     ```swift
     /usr/local/bin/carthage copy-frameworks
     ```
*   Add Input files *$(SRCROOT)/Carthage/Build/iOS/CPImageViewer.framework*

    ​

## Properties

These properties is global and applied to the whole project.

``` swift
/// The viewer style. Defaults to Presentation
public var viewerStyle = CPImageViewerStyle.presentation

/// The image of animation image view
public var image: UIImage?

/// The title of *navigationItem.rightBarButtonItem* when viewerStyle is Push
public var rightBarItemTitle: String?

/// The image of *navigationItem.rightBarButtonItem* when viewerStyle is Push
public var rightBarItemImage: UIImage?

/// The action of *navigationItem.rightBarButtonItem* when viewerStyle is Push
public var rightAction: ((Void) -> (Void))?
```



## Usage

It's very easy to use **CPImageViewer**.

Firstly, conforming to  *CPImageControllerProtocol* protocol and initializing the *animationImageView* or assigning it an image view.
``` swift
class ViewController: UIViewController, ImageControllerProtocol {
  var animationImageView: UIImageView!
}

override func viewDidLoad() {
    animationImageView = UIImageView()
	animationImageView.frame = <#frame#>
	animationImageView.image = <#image#>
	self.view.addSubview(animationImageView)
}
```

Then, presenting the *CPImageViewerViewController*

``` swift
let controller = CPImageViewerViewController()
controller.transitioningDelegate = CPImageViewerAnimator()
controller.image = animationImageView.image 
self.present(controller, animated: true, completion: nil)
```

or pushing the *CPImageViewerViewController*

``` swift
override func viewDidLoad() {
    self.navigationController?.delegate = CPImageViewerAnimator()
}

let controller = CPImageViewerViewController()
controller.viewerStyle = .push
controller.image = animationImageView.image 
controller.title = "CPImageViewer"
self.navigationController?.pushViewController(controller, animated: true)
```



## Requirements

* Swift 4.2
* Xcode 10.0
* iOS 8+

## License

Released under the MIT license. See LICENSE for details.
