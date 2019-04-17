import UIKit
import MessageUI

extension UIViewController {
    public func okAlert(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func email(address: String, subject: String) {
        if MFMailComposeViewController.canSendMail() {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            let appName = Bundle.main.infoDictionary?["CFBundleName"]
            let subject = "\(subject) - \(appName ?? "unknown") \(version ?? "unknown") iOS: \(UIDevice.current.systemVersion)"
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setSubject(subject)
            self.present(mail, animated: true)
        } else {
            okAlert(title: "This device is not setup to send email yet.")
        }
    }
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIViewController {

    func rightButton(title: String?, style: UIBarButtonItem.Style = .plain, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(title: title, style: style, target: target, action: action)
        navigationItem.rightBarButtonItem = button
    }

    func rightButton(systemItem: UIBarButtonItem.SystemItem, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        self.navigationItem.rightBarButtonItem = button
    }

    func addDoneButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissViewController as () -> Void))
    }

    func applyDismissActionToRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem?.action = #selector(self.dismissViewController as () -> Void)
        self.navigationItem.rightBarButtonItem?.target = self
    }

    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    static func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }

    public func printTransitionStates() {
        print("isBeingPresented=\(isBeingPresented)")
        print("isBeingDismissed=\(isBeingDismissed)")
        print("isMovingToParentViewController=\(isMovingToParent)")
        print("isMovingFromParentViewController=\(isMovingFromParent)")
    }
}
