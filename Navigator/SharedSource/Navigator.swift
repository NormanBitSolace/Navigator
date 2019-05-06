import UIKit

public typealias Configure<T> = ((T) -> Swift.Void)?
public typealias SplitConfigure<Master, Detail> = ((Master, Detail) -> Swift.Void)?
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

    /*  First cut, hasn't been tested out
        https://nshipster.com/uisplitviewcontroller/
        https://stackoverflow.com/questions/24135578/how-can-create-a-splitviewcontroller-programmatically-in-swift
        navigator.root(masterType: MainViewController.self, masterStoryboardName: "Main", detailType: MapViewController.self, detailStoryboardName: "Map") { masterVC, detailVC in
            masterVC.delegate = self
            masterVC.title = "Styles"
            self.dataService.viewControllerStyleList { models in
                masterVC.data = models
            }
            detailVC.title = "Astro Doughnut"
            detailVC.setAstroAnnotation()
       }
    */
    @discardableResult
    public func root<Master: UIViewController, Detail: UIViewController>(masterType: Master.Type, masterStoryboardName: String? = nil, detailType: Detail.Type, detailStoryboardName: String? = nil, configure: SplitConfigure<Master, Detail> = nil) -> UISplitViewController {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        let splitViewController =  UISplitViewController()
        var masterVC: Master
        if let name = masterStoryboardName {
            masterVC = UIViewController.loadStoryboard(name)
        } else {
            masterVC = Master.init()
        }
        var detailVC: Detail
        if let name = detailStoryboardName {
            detailVC = UIViewController.loadStoryboard(name)
        } else {
            detailVC = Detail.init()
        }
        rootNavigationController = UINavigationController(rootViewController: masterVC)
        let detailNavigationController = UINavigationController(rootViewController:detailVC)
        splitViewController.viewControllers = [rootNavigationController, detailNavigationController]
        rootNavigationController.navigationItem.leftBarButtonItem =
            splitViewController.displayModeButtonItem
        rootNavigationController.navigationItem.leftItemsSupplementBackButton = true
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()

        masterVC.loadViewIfNeeded()
        detailVC.loadViewIfNeeded()
        if let configure = configure {
            configure(masterVC, detailVC)
        }
       return splitViewController
    }
}

extension Navigator {   // PUSH

    @discardableResult
    public func push<T: UIViewController>(animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = T.init()
        vc.edgesForExtendedLayout = []
        vc.view.backgroundColor = .white // empty vc can perform slugishly
        return push(vc: vc, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    public func push<T: UIViewController>(storyboardName: String, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        let vc = UIViewController.loadStoryboard(storyboardName) as T
        return push(vc: vc, animated: animated, completion: completion, configure: configure)
    }

    @discardableResult
    func push<T: UIViewController>(vc: T, animated: Bool = true, completion: Completion<T> = nil, configure: Configure<T> = nil) -> T {
        if let configure = configure {
            rootNavigationController.applyConfig(vc, configure: configure)
        }
        rootNavigationController.pushViewController(viewController: vc, animated: animated) {
            completion?(vc)
        }
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
        var vcCompletion: (() -> Void)?
        if let completion = completion {
            vcCompletion = {
                completion(vc)
            }
        }

        var topNC = rootNavigationController as UIViewController
        if let presentedNC = rootNavigationController.presentedViewController {
            topNC = presentedNC
        }
        // UIViewController.topMostController()?.present... works for Search when modal
        topNC.present(target, animated: animated, completion: vcCompletion)
/* TODO
        rootNavigationController.present(target, animated: animated, completion: vcCompletion)
         */
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
        var vcCompletion: (() -> Void)?
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
    public func removeChildViewController(childViewController vc: UIViewController, completion: (() -> Void)? = nil) {
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
    @discardableResult
    static public func presentModalOnCurrent<T: UIViewController>(
              type: T.Type? = nil,
              storyboardName: String? = nil,
              wrap: Bool = false,
              animated: Bool = true,
              completion: Completion<T> = nil,
              configure: Configure<T> = nil) -> UIViewController? {
        if let parentVC = UIViewController.topMostController() {
            var vc: UIViewController
            if let storyboardName = storyboardName {
                vc = UIViewController.loadStoryboard(storyboardName) as T
            } else if type != nil {
                vc = T.init()
            } else {
                vc = UIViewController.init()
            }
            if wrap {
                _ = UINavigationController.init(rootViewController: vc)
            }
            vc.loadViewIfNeeded()
            vc.view.frame = parentVC.view.bounds
            if let configure = configure {
                vc.loadViewIfNeeded()
                // swiftlint:disable force_cast
                configure(vc as! T)
                // swiftlint:enable force_cast
            }
            var vcCompletion: (() -> Void)?
            if let completion = completion {
                vcCompletion = {
                    // swiftlint:disable force_cast
                    completion(vc as! T)
                    // swiftlint:enable force_cast
                }
            }
            parentVC.present(vc, animated: animated, completion: vcCompletion)
            return vc
        }
        return nil
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

extension UINavigationController {

    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() ->  Void)) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }

    func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }

    func popToRootViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
}
