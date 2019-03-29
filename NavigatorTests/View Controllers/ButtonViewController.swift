import UIKit

class ButtonViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    var buttonTask: (() -> Void)?
    @IBAction func buttonTap(_ sender: Any) {
        guard let buttonTask = buttonTask else { return }
        buttonTask()
    }
}
