import UIKit

protocol SearchTouchDelegate: class {
    func handleSearchTouch(value: String, vc: UIViewController)
}
class SearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var dataDelegate: TableViewDelegate<String, UITableViewCell>!
    weak var delegate: SearchTouchDelegate?
    var data: [String]? {
        didSet {
            dataDelegate.data = data
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataDelegate = TableViewDelegate(
            data: data,
            cellType: nil,
            decorator: { (cell, model) in
                cell.textLabel?.text = model
        }, touchDelegate: { (indexPath, model) in
            self.delegate?.handleSearchTouch(value: model, vc: self)
        })
        tableView.setAutoSizeHeight()
        dataDelegate.setDelegate(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            dataDelegate.data = data
            tableView.reloadData()
            return
        }
        let filteredData = data?.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
        dataDelegate.data = filteredData
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dataDelegate.data = data
        tableView.reloadData()
    }
}
