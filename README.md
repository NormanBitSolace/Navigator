# Navigator

The Navigator class’s single purpose is to facilitate navigating (push, present modal, popover, and child/container) from one view controller to another from outside of those view controllers.

## The Problem

### Xcode’s default approach
A project created with Xcode automatically marks the `AppDelegate` as the app’s entry point with `@UIApplicationMain`. The problem is that it also binds the storyboard defined by the *Main Interface* setting to the `AppDelegate`’s `UIWindow` member variable. The consequence of this is that the root navigation controller used for all navigation now resides at `AppDelegate`’s `window?.rootViewController?.navigationController` property. Rather than accessing this member variable navigation is often performed from within a view controller e.g. `viewController.push(destinationViewController, animated: true)`.   Apple’s [View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1) states:

<blockquote>
• The shouldPerformSegueWithIdentifier:sender: method gives you an opportunity to prevent a segue from happening. Returning NO from this method causes the segue to fail quietly but does not prevent other actions from happening. For example, a tap in a table row still causes the table to call any relevant delegate methods.
<br>
<br>
• The prepareForSegue:sender: method of the source view controller lets you pass data from the source view controller to the destination view controller. The UIStoryboardSegue object passed to the method contains a reference to the destination view controller along with other segue-related information.
</blockquote>

Inherent in this is:
1. A view controller have logic to decide the next view controller.
1. A view controller have data to pass to the next view controller.
1. A view controller have knowledge of the next view controller e.g. it’s type and delegate requirements.

## A Solution

### An independent object responsible for navigation

Clear the *Main Interface* setting and remove the `AppDelegate`’s `UIWindow` member variable. Create an independent object to create a `UIWindow`, `UINavigationController`, and `UIViewController` and store the reference to the root navigation controller. This object can now perform all navigation from outside a  `UIViewController` and further, removes the need for segues. `Navigator` is such an object that can be managed by popular architecture patterns e.g. `AppController`, `FlowController`, and `Presenter`. This app uses an `AppController` to control the navigation flow (using `Navigator`) and interact with the data layer.

### Additional benefits

`Navigator` provides a configuration callback that allows concerns to be set externally e.g.:
```swift
navigator.push() { vc in
    vc.delegate = self
    vc.data = viewModel
}
```
This prevents `UIViewController` from having knowledge of external concerns e.g. data layer, delegates, view model transformations, etc.

`Navigator` also encapsulates re-occurring implementation details as well as pitfalls including:
1. Consistent API for push, presentModal, popover, and add/remove child
1. `preconditionFailure` for *Is Initial View Controller* setting.
1. `preconditionFailure` for *Custom Class* setting.
1. Ensuring popovers implement `UIPopoverPresentationControllerDelegate` and `modalPresentationStyle`.
1. Ensuring view controllers are fully formed with `loadViewIfNeeded()`.
1. Preventing sluggish behavior caused by empty view controllers.
1. Container view controller details like matching `didMove(toParent)` and `willMove(toParent)`.
