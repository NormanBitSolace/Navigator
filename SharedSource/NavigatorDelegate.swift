import UIKit

enum NavigationType: Hashable {
    case root(UIViewController)
    case push(UIViewController)
    case modal(UIViewController)
    case popover(UIViewController)
    case child(UIViewController)
}

protocol NavigationDelegate {
    func wasShown(_ type: NavigationType)
}

class NavigationManager: NavigationDelegate {
    struct Pair {
        let parent: UIViewController?
        let vc: UIViewController
    }
    var currentVC: UIViewController!
    var pushes = [Pair]()
    var modals = [Pair]()
    var currentPopover: UIViewController?
    var childs = [Pair]()
    func wasShown(_ type: NavigationType) {
        switch type {
        case let .root(vc):
            currentVC = vc
        case let .push(vc):
            pushes.append(Pair(parent: vc.navigationController, vc: vc))
        case let .modal(vc):
            modals.append(Pair(parent: currentVC, vc: vc))
        case let .popover(vc):
            currentPopover = vc
        case let .child(vc):
            modals.append(Pair(parent: nil, vc: vc))
        }
    }

    func exit(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        if let pair = pushes.first(where: {$0.vc === vc}) {
            if let nc = pair.parent as? UINavigationController? {
                if let completion = completion {
                    nc?.popViewController(animated: animated, completion: completion)
                } else {
                    nc?.popViewController(animated: animated)

                }
            }
        } else if let pair = modals.first(where: {$0.vc === vc}) {
            pair.vc.dismiss(animated: animated, completion: completion)
        } else if let pair = childs.first(where: {$0.vc === vc}) {
            pair.vc.willMove(toParent: nil)
            pair.vc.view.removeFromSuperview()
            pair.vc.removeFromParent()
            completion?()

        } else if vc == currentPopover {
            preconditionFailure("Popover exit not implemented yet.")
        } else {
            preconditionFailure("Attempting to exit unknown view controller - expected to have been added in wasShown().")
        }
    }

}
