import UIKit

extension UINavigationController {

    func setLargeNavigation(useLargeNavigation: Bool = true) {
        if useLargeNavigation {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationBar.isTranslucent = false
        } else {
            navigationBar.prefersLargeTitles = false
            // navigationItem.largeTitleDisplayMode = .never
        }
    }
}
