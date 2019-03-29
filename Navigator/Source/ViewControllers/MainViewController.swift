import UIKit

protocol MainViewControllerDelegate: class {
    func viewControllerStyleChosen(_ model: ViewControllerStyleModel)
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MainViewControllerDelegate?
    var dataDelegate: TableViewDelegate<ViewControllerStyleModel, UITableViewCell>!
    var data: [ViewControllerStyleModel]? {
        didSet {
            dataDelegate.data = data
            tableView.reloadOnMain()
        }
    }
    final override func viewDidLoad() {
        super.viewDidLoad()
        dataDelegate = TableViewDelegate(
            cellType: nil,
            decorator: { (cell, model) in
                cell.textLabel?.text = model.title
        }, touchDelegate: { (indexPath, model) in
            self.delegate?.viewControllerStyleChosen(model)
        })
        tableView.setAutoSizeHeight()
        dataDelegate.setDelegate(tableView)
    }
}
