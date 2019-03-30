import XCTest
@testable import Navigator

class NavigatorChildTests: XCTestCase {

    static let navigator = Navigator()

    override class func setUp() {
        super.setUp()
        Navigator.bundle = Bundle(for: NavigatorChildTests.self)
        navigator.root(type: OrangeViewController.self, storyboardName: "Orange") { _ in }
    }

    override func setUp() { }

    override func tearDown() { }

    func testRemoveChildUIViewControllerFromTop() {
        let topVC = NavigatorChildTests.navigator.topViewController!

        let vc: UIViewController = NavigatorChildTests.navigator.addChildViewController()
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        XCTAssertTrue(topVC.view.subviews.contains(vc.view))
        NavigatorChildTests.navigator.removeChildViewController(childViewController: vc) {
            XCTAssertFalse(topVC.view.subviews.contains(vc.view))
        }

        let cvc: OrangeViewController = NavigatorChildTests.navigator.addChildViewController()
        XCTAssertNotNil(cvc)
        XCTAssertEqual("OrangeViewController", String(describing: cvc.classForCoder))
        XCTAssertTrue(topVC.view.subviews.contains(cvc.view))
        NavigatorChildTests.navigator.removeChildViewController(childViewController: cvc) {
            XCTAssertFalse(topVC.view.subviews.contains(cvc.view))
        }
   }

    func testChildUIViewController() {
        let vcInferred = NavigatorChildTests.navigator.addChildViewController()
        XCTAssertNotNil(vcInferred)
        XCTAssertEqual("UIViewController", String(describing: vcInferred.classForCoder))

        let vc: UIViewController = NavigatorChildTests.navigator.addChildViewController()
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
    }

    func testChildCustomViewController() {
        let vc: OrangeViewController = NavigatorChildTests.navigator.addChildViewController()
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
    }

    func testChildWithStoryboard() {
        let vc: OrangeViewController = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Orange")
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Orange")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("OrangeViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testChildWithUnassociatedStoryboard() {
        let vc: UIViewController = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Unassociated")
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Unassociated")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("UIViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testChildUIViewControllerConfigure() {
        NavigatorChildTests.navigator.addChildViewController() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }

        NavigatorChildTests.navigator.addChildViewController() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }

    func testChildCustomViewControllerConfigure() {
        let _: OrangeViewController = NavigatorChildTests.navigator.addChildViewController() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testChildWithStoryboardConfigure() {
        let _: OrangeViewController = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
        NavigatorChildTests.navigator.addChildViewController(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testChildWithUnassociatedStoryboardConfigure() {
        let _: UIViewController = NavigatorChildTests.navigator.addChildViewController(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
        NavigatorChildTests.navigator.addChildViewController(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }
}
