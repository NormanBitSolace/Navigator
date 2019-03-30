import XCTest
@testable import Navigator

class NavigatorRootTests: XCTestCase {

    let navigator = Navigator()

    override class func setUp() {
        super.setUp()
        Navigator.bundle = Bundle(for: NavigatorRootTests.self)
    }

    func testRootViewController() {
//        let navigator = Navigator()
        let vcInferred = navigator.root(type: UIViewController.self)
        XCTAssertNotNil(vcInferred)
        XCTAssertEqual("UIViewController", String(describing: vcInferred.classForCoder))
        guard let nc = vcInferred.navigationController else { preconditionFailure("Test failed.")}
        XCTAssertNotNil(nc)
        XCTAssertEqual("UINavigationController", String(describing: nc.classForCoder))

        let vc: UIViewController = navigator.root(type: UIViewController.self)
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        guard let nc1 = vc.navigationController else { preconditionFailure("Test failed.")}
        XCTAssertNotNil(nc1)
        XCTAssertEqual("UINavigationController", String(describing: nc1.classForCoder))
    }

    func testCustomRootViewController() {
//        let navigator = Navigator()
        let vc = navigator.root(type: OrangeViewController.self)
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        guard let nc = vc.navigationController else { preconditionFailure("Test failed.")}
        XCTAssertNotNil(nc)
        XCTAssertEqual("UINavigationController", String(describing: nc.classForCoder))
    }

    func testCustomRootViewControllerStoryboard() {
//        let navigator = Navigator()
        let vc = navigator.root(type: OrangeViewController.self, storyboardName: "Orange")
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        guard let nc = vc.navigationController else { preconditionFailure("Test failed.")}
        XCTAssertNotNil(nc)
        XCTAssertEqual("UINavigationController", String(describing: nc.classForCoder))
    }

    func testRootUIViewControllerConfigure() {
//        let navigator = Navigator()
        navigator.root(type: UIViewController.self) { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
            guard let nc = vc.navigationController else { preconditionFailure("Test failed.")}
            XCTAssertNotNil(nc)
            XCTAssertEqual("UINavigationController", String(describing: nc.classForCoder))
        }
    }

    func testRootCustomViewControllerConfigure() {
//        let navigator = Navigator()
        navigator.root(type: OrangeViewController.self) { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
            guard let nc = vc.navigationController else { preconditionFailure("Test failed.")}
            XCTAssertNotNil(nc)
            XCTAssertEqual("UINavigationController", String(describing: nc.classForCoder))
        }
    }

    func testRootWithStoryboardConfigure() {
//        let navigator = Navigator()
        navigator.root(type: OrangeViewController.self, storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
        navigator.root(type: OrangeViewController.self, storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }
}
