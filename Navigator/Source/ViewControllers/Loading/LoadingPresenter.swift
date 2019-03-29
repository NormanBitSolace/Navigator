import UIKit

class LoadingPresenter {

    let navigator: Navigator
    var loadingViewController: UIViewController?
    var isShowing: Bool { return loadingViewController != nil }

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func show() {
        guard let topVC = self.navigator.topViewController else { return }
        loadingViewController = navigator.addChildViewController(storyboardName: "Loading") { vc in
            vc.view.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
            vc.view.center = topVC.view.bounds.center
        }
    }

    @discardableResult
    func hide() -> Bool {
        guard let vc = loadingViewController else { return false }
        navigator.removeChildViewController(childViewController: vc)
        loadingViewController = nil
        return true
    }
}
