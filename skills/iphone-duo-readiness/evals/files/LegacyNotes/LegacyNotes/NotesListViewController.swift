import UIKit

final class NotesListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newNote))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.rowHeight = LayoutHelpers.isLandscape ? 44 : 64
    }

    @objc private func newNote() {
        navigationController?.pushViewController(EditorViewController(), animated: true)
    }
}
