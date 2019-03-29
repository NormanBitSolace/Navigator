import UIKit

class CompletionViewController: UIViewController {

    var loaded = false
    var didWillAppear = false
    var didAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didWillAppear = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear = true
    }
}
