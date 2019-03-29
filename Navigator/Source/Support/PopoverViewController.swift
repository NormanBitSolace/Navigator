import UIKit

class PopoverViewController: UIViewController {}
class PopoverTableViewController: UITableViewController {}

extension PopoverViewController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension PopoverTableViewController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
