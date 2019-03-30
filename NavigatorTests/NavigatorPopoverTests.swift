import XCTest
@testable import Navigator

class NavigatorPopoverTests: XCTestCase {

    static let navigator = Navigator()
    static var anchor: UIView?

    override class func setUp() {
        super.setUp()
        Navigator.bundle = Bundle(for: NavigatorPopoverTests.self)
        navigator.root(type: ButtonViewController.self, storyboardName: "Button") { vc in
            anchor = vc.button
        }
    }

    override func setUp() { }

    override func tearDown() { }



    func testPopoverUIViewControllerCompletion() {
        let _: CompletionPopoverViewController = NavigatorPopoverTests.navigator.presentPopover(anchor: NavigatorPopoverTests.anchor as Any, completion: { vc in
            XCTAssertTrue(vc.loaded)
            XCTAssertTrue(vc.didWillAppear)
            XCTAssertTrue(vc.didAppear)
        })
    }

    func testPopoverUIViewController() {
        let vc: PopoverViewController = NavigatorPopoverTests.navigator.presentPopover(anchor: NavigatorPopoverTests.anchor as Any)
        XCTAssertNotNil(vc)
        XCTAssertEqual("PopoverViewController", String(describing: vc.classForCoder))
    }
}
