import UIKit

class SearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var dataDelegate: TableViewDelegate<String, UITableViewCell>!
    let data = (1...100).map { $0.spellOut }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataDelegate = TableViewDelegate(
            data: data,
            cellType: nil,
            decorator: { (cell, model) in
                cell.textLabel?.text = model
        }, touchDelegate: { (indexPath, model) in
            print(model)
        })
        tableView.setAutoSizeHeight()
        dataDelegate.setDelegate(tableView)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            dataDelegate.data = data
            tableView.reloadData()
            return
        }
        var includeNumbers = searchText.lowercased()
        if let intRepresentation = Int(searchText) {
            includeNumbers = intRepresentation.spellOut
        }
        let filteredData = data.filter { $0.contains(includeNumbers) }
        dataDelegate.data = filteredData
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dataDelegate.data = data
        tableView.reloadData()
    }
}
