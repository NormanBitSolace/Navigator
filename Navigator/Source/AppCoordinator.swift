import UIKit
import MapKit

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
        navigator.root(type: MainViewController.self, storyboardName: "Main") { vc in
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

    @objc func handleInfoTap() {
        Navigator.presentModalOnCurrent(type: ModalAlertViewController.self, storyboardName: "ModalAlert") { vc in
            vc.alertTitle = "Introducing Josie!"
            vc.circleView.borderWidth = 18
            vc.circleView.borderColor = .orange
            vc.titleLabel.textColor = .orange
        }
    }
}

extension AppCoordinator: MainViewControllerDelegate {

    func viewControllerStyleChosen(_ model: ViewControllerStyleModel) {
        switch model.style {
        case .search:
            let _: SearchViewController = navigator.push(storyboardName: "Search") { vc in
                vc.navigationController?.setLargeNavigation()
                vc.title = "Numbers"
                vc.data = (1...100).map { $0.spellOut }
                vc.delegate = self
                vc.addDoneButton()
                vc.navigationItem.rightBarButtonItem?.addAction {
                    vc.dismissViewController()
                }
           }
        case .email:
            navigator.topViewController?.email(address: "test@gmail.com", subject: "Navigator")
        case .popover:
            showPopoverController()
        case .childLoading:
            loadingPresenter.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                self.loadingPresenter.hide()
            }
        case .html:
            showHtml()
        case .push:
            let _: MapViewController = navigator.push(storyboardName: "Map") { vc in
                vc.navigationController?.setLargeNavigation()
                vc.title = "Astro Doughnut"
                vc.setAstroAnnotation()
            }
        case .modal:
            navigator.presentModal(wrap: true) { vc in
                vc.addDoneButton()
                vc.navigationController?.setLargeNavigation()
                vc.view.addEmitterView(imageType: .confetti)
                vc.title = "Confetti"
            }
        case .modalAlert:
            let _: ModalAlertViewController = navigator.presentModal(storyboardName: "ModalAlert") { vc in
                vc.alertTitle = "Touch to continue!"
            }
        case .pushWithStoryBoard:
            navigator.push(storyboardName: "Image") { vc in
                vc.rightButton(title: "Info", target: self, action: #selector(self.handleInfoTap))
            }
        }
    }
}

extension AppCoordinator: SearchTouchDelegate {
    func handleSearchTouch(value: String, vc: UIViewController) {
        print(value)
    }
}
