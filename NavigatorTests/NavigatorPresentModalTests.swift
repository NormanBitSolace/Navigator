import XCTest
@testable import Navigator

class NavigatorPresentModalTests: XCTestCase {

    static let navigator = Navigator()

    override class func setUp() {
        super.setUp()
        Navigator.bundle = Bundle(for: NavigatorPresentModalTests.self)
        navigator.root(vc: OrangeViewController.self, storyboardName: "Orange") { _ in }
    }

    override func setUp() { }

    override func tearDown() { }

    func testPresentModalUIViewControllerCompletion() {
        let _: CompletionViewController = NavigatorPresentModalTests.navigator.presentModal(completion: { vc in
            XCTAssertTrue(vc.loaded)
            XCTAssertTrue(vc.didWillAppear)
            XCTAssertTrue(vc.didAppear)
        })
    }

    func testPresentModalUIViewController() {
        let vcInferred = NavigatorPresentModalTests.navigator.presentModal()
        XCTAssertNotNil(vcInferred)
        XCTAssertNil(vcInferred.navigationController)
        XCTAssertEqual("UIViewController", String(describing: vcInferred.classForCoder))

        let vc: UIViewController = NavigatorPresentModalTests.navigator.presentModal()
        XCTAssertNotNil(vc)
        XCTAssertNil(vc.navigationController)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
    }

    func testPresentModalUIViewControllerWrap() {
        let vcInferred = NavigatorPresentModalTests.navigator.presentModal(wrap: true)
        XCTAssertNotNil(vcInferred)
        XCTAssertNotNil(vcInferred.navigationController)
        XCTAssertEqual("UIViewController", String(describing: vcInferred.classForCoder))

        let vc: UIViewController = NavigatorPresentModalTests.navigator.presentModal(wrap: true)
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vcInferred.navigationController)
       XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
    }

    func testPresentModalCustomViewController() {
        let vc: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal()
        XCTAssertNotNil(vc)
        XCTAssertNil(vc.navigationController)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
    }

    func testPresentModalCustomViewControllerWrap() {
        let vc: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(wrap: true)
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.navigationController)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
    }

    func testPresentModalWithStoryboard() {
        let vc: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange")
        XCTAssertNotNil(vc)
        XCTAssertNil(vc.navigationController)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("OrangeViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPresentModalWithStoryboardWrap() {
        let vc: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange", wrap: true)
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.navigationController)
        XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("OrangeViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPresentModalWithUnassociatedStoryboard() {
        let vc: UIViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated")
        XCTAssertNotNil(vc)
        XCTAssertNil(vc.navigationController)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated")
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertEqual("UIViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPresentModalWithUnassociatedStoryboardWrap() {
        let vc: UIViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated", wrap: true)
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.navigationController)
        XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        let unspecifiedVC = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated", wrap: true)
        XCTAssertNotNil(unspecifiedVC)
        XCTAssertNotNil(vc.navigationController)
        XCTAssertEqual("UIViewController", String(describing: unspecifiedVC.classForCoder))
    }

    func testPresentModalUIViewControllerConfigure() {
        NavigatorPresentModalTests.navigator.presentModal() { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
           XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }

        NavigatorPresentModalTests.navigator.presentModal() { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalUIViewControllerConfigureWrap() {
        NavigatorPresentModalTests.navigator.presentModal(wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }

        NavigatorPresentModalTests.navigator.presentModal(wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalCustomViewControllerConfigure() {
        let _: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal() { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalCustomViewControllerConfigureWrap() {
        let _: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalWithStoryboardConfigure() {
        let _: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
        NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange") { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalWithStoryboardConfigureWrap() {
        let _: OrangeViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange", wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
        NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Orange", wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("OrangeViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalWithUnassociatedStoryboardConfigure() {
        let _: UIViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
        NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated") { vc in
            XCTAssertNotNil(vc)
            XCTAssertNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }

    func testPresentModalWithUnassociatedStoryboardConfigureWrap() {
        let _: UIViewController = NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated", wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
        NavigatorPresentModalTests.navigator.presentModal(storyboardName: "Unassociated", wrap: true) { vc in
            XCTAssertNotNil(vc)
            XCTAssertNotNil(vc.navigationController)
            XCTAssertEqual("UIViewController", String(describing: vc.classForCoder))
        }
    }
}
