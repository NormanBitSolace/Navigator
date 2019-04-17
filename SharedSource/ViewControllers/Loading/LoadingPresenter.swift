import UIKit

class LoadingPresenter {

    let navigator: Navigator
    var loadingViewController: UIViewController?
    var isShowing: Bool { return loadingViewController != nil }

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func show(message: String? = nil) {
        loadingViewController = Navigator.presentModalOnCurrent { vc in
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.alpha = 0.9
            vc.view.isOpaque = false
            vc.view.backgroundColor = .white
            vc.rightButton(systemItem: .cancel, target: vc, action: #selector(vc.dismissViewController))
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 240, height: 180)))
            vc.view.addSubview(imageView)
            imageView.constrainToCenter(to: vc.view)
            let animationImages = Data(localFile: "loading.gif").animationImages()
            imageView.animationImages = animationImages
            imageView.startAnimating()
            let messageLabel = UILabel(frame: .zero)
            messageLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
            messageLabel.text = message
            vc.view.addSubview(messageLabel)
            messageLabel.constrainToCenter(to: vc.view, dy: -90)
        }
    }

    @discardableResult
    func hide(completion: (() -> Void)? = nil) -> Bool {
        var didHide = false
        if let vc = self.loadingViewController {
            didHide = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                vc.dismiss(animated: false) {
                    self.loadingViewController = nil
                    completion?()
                }
            }
        }
        return didHide
    }
}
