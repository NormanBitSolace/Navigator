import UIKit

public typealias Configure<T> = ((T) -> Swift.Void)?
public typealias Completion<T> = ((T) -> Swift.Void)?

public class Navigator: NSObject {

    var window: UIWindow!
    var rootNavigationController: UINavigationController!
    var topViewController: UIViewController? {
        return rootNavigationController.topViewController
    }
    static var bundle = Bundle.main // expose for testing

    // Wraps vc in UINavigationController if one doesn't exist, a single vc app doesn't require Navigator's functionality.
    @discardableResult
    public func root<T: UIViewController>(type: T.Type, storyboardName: String? = nil, configure: Configure<T> = nil) -> T {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        var rootVC: T
        if let name = storyboardName {
            rootVC = UIViewController.loadStoryboard(name)
        } else {
            rootVC = T.init()
        }
        if let navigationController = rootVC.navigationController {
            rootNavigationController = navigationController
        } else {
            rootNavigationController = UINavigationController(rootViewController: rootVC)
        }
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        if let configure = configure {
            rootNavigationController.applyConfig(rootVC, configure: configure)
        }
        return rootVC
    }
}

extension Navigator {   // PUSH

    @discardableResult
    public func push<T: UIViewController>(animated: Bool = true, configure: Configure<T> = nil) -> T {
        let vc = T.init()
         vc.edgesForExtendedLayout = []
        vc.view.backgroundColor = .white // empty vc can perform slugishly
        return push(vc: vc, animated: animated, configure: configure)
    }

    @discardableResult
    public func push<T: UIViewController>(storyboardName: String, animated: Bool = true, configure: Configure<T> = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return push(vc: vc, animated: animated, configure: configure)
    }

    @discardableResult
    func push<T: UIViewController>(vc: T, animated: Bool = true, configure: Configure<T> = nil) -> T {
        if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        rootNavigationController.pushViewController(vc, animated: animated)
        return vc
    }
}

extension Navigator {   //  MODAL

    @discardableResult
    public func presentModal<T: UIViewController>(wrap: Bool = false, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        vc.view.backgroundColor = .white // empty vc can perform slugishly
        return presentModal(vc: vc, wrap: wrap, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    public func presentModal<T: UIViewController>(storyboardName: String, wrap: Bool = false, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return presentModal(vc: vc, wrap: wrap, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    func presentModal<T: UIViewController>(vc: T, wrap: Bool = false, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        if wrap {
            _ = UINavigationController.init(rootViewController: vc)
        }
       if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        let target = vc.navigationController ?? vc
        var vcCompletion: (()->())? = nil
        if let completion = completion {
            vcCompletion = {
                completion(vc)
            }
        }
        rootNavigationController.present(target, animated: animated, completion: vcCompletion)
        return vc
    }
}

extension Navigator {   //  POPOVER

    @discardableResult
    public func presentPopover<T: UIViewController>(anchor: Any, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        vc.view.backgroundColor = .white // empty vc can perform slugishly
        return presentPopover(vc: vc, anchor: anchor, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    public func presentPopover<T: UIViewController>(storyboardName: String, anchor: Any, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return presentPopover(vc: vc, anchor: anchor, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    func presentPopover<T: UIViewController>(vc: T, anchor: Any, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let target = vc.navigationController ?? vc
        target.modalPresentationStyle = .popover
        rootNavigationController.applyPopoverConfig(vc, anchor: anchor)
        if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        var vcCompletion: (()->())? = nil
        if let completion = completion {
            vcCompletion = {
                completion(vc)
            }
        }
        topViewController?.present(target, animated: animated, completion: vcCompletion)
        return vc
    }
}

extension Navigator {   //  CHILD

    @discardableResult
    public func addChildViewController<T: UIViewController>(container: UIViewController? = nil, animated: Bool = true, configure: Configure<T> = nil) -> T {
        let vc = T.init()
        return addChildViewController(vc: vc, container: container, animated: animated, configure: configure)
    }

    @discardableResult
    public func addChildViewController<T: UIViewController>(storyboardName: String, container: UIViewController? = nil, animated: Bool = true, configure: Configure<T> = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return addChildViewController(vc: vc, container: container, animated: animated, configure: configure)
    }

    func addChildViewController<T: UIViewController>(vc: T, container: UIViewController? = nil, animated: Bool = true, configure: Configure<T>) -> T {
        guard let topVC = topViewController else { preconditionFailure("App assumes a top view controller.")}
        let parentVC = container == nil ? topVC : container!
        parentVC.addChild(vc)
        if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
        return vc
    }
    public func removeChildViewController(childViewController vc: UIViewController, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            completion?()
        }
    }
}

/*
     Provides a way to show a modal view controller on top of the current window without requiring a Navigator instance.
 */
extension Navigator {
    static public func presentModalOnCurrent<T: UIViewController>(type: T.Type, storyboardName: String, wrap: Bool = false, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) {
        if let window = UIApplication.shared.keyWindow {
            if let parentVC = window.rootViewController {
                let vc = UIViewController.loadStoryboard(storyboardName) as T
                vc.loadViewIfNeeded()
                vc.view.frame = parentVC.view.bounds
                if let configure = configure {
                    vc.loadViewIfNeeded()
                    configure(vc)
                }
                var vcCompletion: (()->())? = nil
                if let completion = completion {
                    vcCompletion = {
                        completion(vc)
                    }
                }
               parentVC.present(vc, animated: animated, completion: vcCompletion)
            }
        }
    }
}

fileprivate extension UIViewController {

    static func loadStoryboard<T: UIViewController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: Navigator.bundle)
        let vc = storyboard.instantiateInitialViewController()
        if let navigationController = vc as? UINavigationController,
            let vc = navigationController.topViewController as? T {
            return vc
        } else if let vc = vc as? T {
            return vc
        } else {
            fatalError(
                """

                    --- Storyboard must have Custom Class set to \(T.description()). ---
                    --- Storyboard must have Is Initial View Controller option set to on. ---


                    """
            )
        }
    }

    func applyConfig<T: UIViewController>(_ vc: T, configure: Configure<T>) {
        vc.view.frame = view.bounds
        if let configure = configure {
            vc.loadViewIfNeeded()
            configure(vc)
        }
    }

    var popoverDelegateErrorMessage: String {
        return """


        --- A popover view controller must derive from PopoverViewController OR implement: ---

        extension ViewController: UIPopoverPresentationControllerDelegate {

        public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
        }

        public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        }
        }

        """
    }

    func applyPopoverConfig(_ vc: UIViewController, anchor: Any) {
        guard let popoverDelegate = vc as? UIPopoverPresentationControllerDelegate else { fatalError(popoverDelegateErrorMessage) }
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = popoverDelegate
        if let barButtonItem = anchor as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let sourceView = anchor as? UIView {
            vc.popoverPresentationController?.sourceView = sourceView
            vc.popoverPresentationController?.sourceRect = sourceView.bounds
        }
    }
}

extension Navigator {   //  ALERT

    func singleButtonAlert(buttonLabel: String, title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonLabel, style: .default, handler: handler)
        alertController.addAction(okAction)
        rootNavigationController.present(alertController, animated: true, completion: nil)
    }
}
