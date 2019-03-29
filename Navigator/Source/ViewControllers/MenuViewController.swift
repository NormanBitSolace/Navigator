import UIKit

class MenuViewController: UITableViewController {
    var tableViewDelegate: TableViewDelegate<String, UITableViewCell>? {
        didSet { tableViewDelegate?.setDelegate(tableView) }
    }
    var data: [String]? {
        didSet {
            tableViewDelegate?.data = data
            tableView.reloadData()
        }
    }
}

extension MenuViewController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
