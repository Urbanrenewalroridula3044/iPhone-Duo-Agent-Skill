import UIKit

final class EditorViewController: UIViewController {
    private let textView = UITextView()
    private let toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        view.addSubview(toolbar)

        toolbar.items = [
            UIBarButtonItem(title: "Bold", style: .plain, target: nil, action: nil),
            UIBarButtonItem(title: "Italic", style: .plain, target: nil, action: nil),
            .flexibleSpace(),
            UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil),
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset = view.safeAreaInsets.left
        let width = view.bounds.width - inset * 2
        toolbar.frame = CGRect(x: inset, y: view.bounds.height - view.safeAreaInsets.bottom - 44, width: width, height: 44)
        textView.frame = CGRect(x: inset, y: view.safeAreaInsets.top, width: width, height: toolbar.frame.minY - view.safeAreaInsets.top)
    }
}
