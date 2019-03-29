import UIKit

final class AppCoordinator: NSObject {

    let loadingPresenter: LoadingPresenter
    let navigator: Navigator
    let dataService: DataService

    init(appNavigator: Navigator, dataService: DataService) {
        self.navigator = appNavigator
        self.dataService = dataService
        loadingPresenter = LoadingPresenter(navigator: navigator)
    }

    func start() {
        navigator.root(vc: MainViewController.self, storyboardName: "Main") { vc in
            vc.delegate = self
            vc.title = "Styles"
           self.dataService.viewControllerStyleList { models in
                vc.data = models
            }
        }
        navigator.rootNavigationController.setLargeNavigation()
    }

    func showPopoverController() {
        let _: ShowPopoverViewController = navigator.push(storyboardName: "ShowPopover") { vc in
            vc.title = "Popover"
            vc.buttonTask = {
                let _: MenuViewController = self.navigator.presentPopover(storyboardName: "Menu", anchor: vc.anchor) { popover in
                    let data = ["strange", "tired", "amped", "like coding"]
                    popover.tableViewDelegate = TableViewDelegate(data: data,
                        decorator: { (cell, model) in
                            cell.textLabel?.text = model
                    }, touchDelegate: { (indexPath, model) in
                        vc.label.text = "I feel \(model)!"
                        popover.dismiss(animated: true)
                    })
                    popover.data = data
                    popover.preferredContentSize = CGSize(width: 150, height: data.count*44)
                    popover.popoverPresentationController?.permittedArrowDirections = .up
               }
            }
        }
    }

    func showHtml() {
        navigator.push() { vc in
            if let path = Bundle.main.path(forResource: "Test", ofType: "htm"),
                let html = try? String(contentsOfFile: path) {
                vc.view.addWebView(withHtml: html)
            }
            vc.title = "HTML"
        }
    }
}

extension AppCoordinator: MainViewControllerDelegate {

    func viewControllerStyleChosen(_ model: ViewControllerStyleModel) {
        switch model.style {
        case .email:
            navigator.topViewController?.email(address: "test@gmail.com", subject: "Navigator")
        case .popover:
            showPopoverController()
        case .childLoading:
            if loadingPresenter.isShowing {
                loadingPresenter.hide()
            } else {
                loadingPresenter.show()
            }
        case .html:
            showHtml()
        case .push:
            navigator.push() { vc in
                vc.view.addEmitterView(imageType: .confetti)
                vc.title = "Confetti"
            }
       case .modal:
            navigator.presentModal(wrap: true) { vc in
                vc.addDoneButton()
                vc.navigationController?.setLargeNavigation()
                vc.view.addEmitterView(imageType: .confetti)
                vc.title = "Confetti"
            }
        case .pushWithStoryBoard:
            navigator.push(storyboardName: "Image")
        }
    }
}
