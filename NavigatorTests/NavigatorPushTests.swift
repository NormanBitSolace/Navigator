import XCTest
@testable import Navigator

class NavigatorPushTests: XCTestCase {

    static let navigator = Navigator()

    override class func setUp() {
        super.setUp()
        Navigator.bundle = Bundle(for: NavigatorPushTests.self)
        navigator.root(type: OrangeViewController.self, storyboardName: "Orange") { _ in }
    }

    override func setUp() { }

    override func tearDown() { }

    func testPushUIViewController() {
        let vcInferred = NavigatorPushTests.navigator.push()
        XCTAssertNotNil(vcInferred)
        XCTAssertEqual("UIViewController", String(describing: vcInferred.classForCoder))

        let vc: UIViewController = NavigatorPushTests.navigator.push()
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
    }

    func testPushCustomViewController() {
        let vc: OrangeViewController = NavigatorPushTests.navigator.push()
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
    }

    func testPushWithStoryboard() {
        let vc: OrangeViewController = NavigatorPushTests.navigator.push(storyboardName: "Orange")
        XCTAssertNotNil(vc)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPushTests.navigator.push(storyboardName: "Orange")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("OrangeViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPushWithUnassociatedStoryboard() {
        let vc: UIViewController = NavigatorPushTests.navigator.push(storyboardName: "Unassociated")
        XCTAssertNotNil(vc)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPushTests.navigator.push(storyboardName: "Unassociated")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("UIViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPushUIViewControllerConfigure() {
        NavigatorPushTests.navigator.push() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }

        NavigatorPushTests.navigator.push() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }

    func testPushCustomViewControllerConfigure() {
        let _: OrangeViewController = NavigatorPushTests.navigator.push() { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPushWithStoryboardConfigure() {
        let _: OrangeViewController = NavigatorPushTests.navigator.push(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
        NavigatorPushTests.navigator.push(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPushWithUnassociatedStoryboardConfigure() {
        let _: UIViewController = NavigatorPushTests.navigator.push(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
        NavigatorPushTests.navigator.push(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }
}
