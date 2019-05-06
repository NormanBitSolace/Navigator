import UIKit

/*
 A square UIView with rounded corners so that it appears as a circle, and sizes it's contained UILabel as a square that fits within it's circle
 */
class CircleView: UIView {
    var borderWidth: CGFloat = 5
    var borderColor: UIColor = .lightGray

    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let wid = bounds.size.width
        layer.cornerRadius = wid / 2.0
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        labelWidthConstraint.constant = CGRect.squareFitsInCircle(withDiameter: wid - borderWidth*2).size.width
    }
}

class ModalAlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    var alertTitle: String? {
        didSet {
            titleLabel.text = alertTitle
        }
    }

    @objc func handleTap() {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        view.applyTapGesture(target: self, action: #selector(handleTap))
    }
}
