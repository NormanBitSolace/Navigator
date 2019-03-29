import UIKit

class ShowPopoverViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var buttonTask: (() -> Void)?
    var anchor: Any { return button as Any }

    @IBAction func buttonTap(_ sender: Any) {
        guard let buttonTask = buttonTask else { return }
        buttonTask()
    }
}
