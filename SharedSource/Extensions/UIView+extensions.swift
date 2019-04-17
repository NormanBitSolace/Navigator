import UIKit
import WebKit

extension UIView {

    func constrain(to target: UIView, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            target.addConstraints([
                target.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: -padding.left),
                target.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -padding.top),
                target.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: padding.right),
                target.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: padding.bottom)
                ])
        } else {
            target.addConstraint(NSLayoutConstraint(item: target, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -padding.top))
            target.addConstraint(NSLayoutConstraint(item: target, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: -padding.left))
            target.addConstraint(NSLayoutConstraint(item: target, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: padding.right))
            target.addConstraint(NSLayoutConstraint(item: target, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: padding.bottom))
        }
    }

    func constrainToCenter(to parent: UIView, dx: CGFloat = 0,
                           dy: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: dx).isActive = true
        centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: dy).isActive = true
    }

    func constrainToParentBounds(_ child: UIView) {
        child.constrain(to: self)
    }
}

extension UIView {
    @discardableResult public func addWebView(withHtml html: String) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        self.addSubview(webView)
        webView.constrain(to: self)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.isUserInteractionEnabled = true
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
}

extension UIView {

    @discardableResult func addExternalBorder(borderWidth: CGFloat = 2.0, borderColor: UIColor = .white) -> CALayer {
        let gap = borderWidth + 1.0
        let externalBorder = CALayer()
        externalBorder.frame = CGRect(x: -gap, y: -gap, width: frame.size.width + 2 * gap, height: frame.size.height + 2 * gap)
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = "externalBorder"

        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false

        return externalBorder
    }

    func removeExternalBorders() {
        layer.sublayers?.filter { $0.name == "externalBorder" }.forEach {
            $0.removeFromSuperlayer()
        }
    }

    func removeExternalBorder(externalBorder: CALayer) {
        guard externalBorder.name == "externalBorder" else { return }
        externalBorder.removeFromSuperlayer()
    }

}

extension UIView {
    // https://swiftforward.wordpress.com/2015/12/04/labels-with-padding-in-ios/
    func withPadding(_ padding: UIEdgeInsets = .zero) -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.constrain(to: container, padding: padding)
        return container
    }
}

public extension UIView {

    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }

    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }

    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }

    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.centerY) }
    }
    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX, y: newValue) }
    }

    var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
}

extension UIView {

    class func subviewsDeep<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = subviewsDeep(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }

    func subviewsDeep<T: UIView>() -> [T] {
        return UIView.subviewsDeep(view: self) as [T]
    }
}

/*
 Adds a block based touch handler to a view by using this wrapper e.g. for UILabel taps

 let view = AddTapAction(toView: label) {
 appCoordinator.showLifeschoolVideo(urlStr)
 }
 */
class AddTapAction: UIView {
    var touchHandler: (() -> Void)?

    @discardableResult
    init(toView view: UIView, touchHandler: @escaping () -> Void) {
        self.touchHandler = touchHandler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.constrain(to: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tapGesture)
    }

    deinit {
        if let recognizer = gestureRecognizers?.first {
            removeGestureRecognizer(recognizer)
        }
        touchHandler = nil
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let handler = touchHandler {
            handler()
        }
    }

}

extension UIView {
    var borderUIColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}

extension UIView {
    func applyTapGesture(target: Any, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
    }
}

// Use blocks with UIControls e.g. button.addAction { print("touched") }
class ClosureSleeve {
    let closure: () -> Void

    init(attachTo: AnyObject, closure: @escaping () -> Void) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

extension UIBarButtonItem {
    func addAction(act: @escaping () -> Void) {
        let sleeve = ClosureSleeve(attachTo: self, closure: act)
        self.action = #selector(ClosureSleeve.invoke)
        target = sleeve
    }
}
