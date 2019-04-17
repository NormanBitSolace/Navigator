import UIKit

class TableViewDelegate<ModelType, CellType: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier: String?
    let decorator: (UITableViewCell, ModelType) -> Void
    let touchDelegate: ((IndexPath, ModelType) -> Void)?
    var swipeActions: [UITableViewRowAction]?
    var data: [ModelType]?

    init<CellType: UITableViewCell>(data: [ModelType]? = nil,
                                    cellType: CellType.Type? = nil,
                                    decorator: @escaping (UITableViewCell, ModelType) -> Void,
                                    touchDelegate: ((IndexPath, ModelType) -> Void)?) {
        self.data = data
        self.cellIdentifier = cellType == nil ? nil : String(describing: CellType.self)
        self.decorator = decorator
        self.touchDelegate = touchDelegate
    }

    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let identifier = cellIdentifier {
            guard let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CellType else {
                preconditionFailure("Expected cell identifier to be named the same as it's type.")
            }
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "generic")
        }
        if let model = data?[indexPath.row] {
            decorator(cell, model)
        }
        return cell
    }

    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let touchDelegate = touchDelegate else { return }
        if let model = data?[indexPath.row] {
            touchDelegate(indexPath, model)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    final func setDelegate(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return swipeActions
    }
}
extension UITableView {
    final func setAutoSizeHeight(_ estimatedRowHeight: CGFloat = 44) {
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableView.automaticDimension
    }

    func reloadOnMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
