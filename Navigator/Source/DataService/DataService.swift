import Foundation

protocol DataService: class {
    func viewControllerStyleList(completion: ([ViewControllerStyleModel]) -> Void)
}

enum ViewControllerStyle: Int {
    case popover
    case modal, modalAlert, search
    case push, pushWithStoryBoard
    case childLoading
    case email, html

    // page controller, master/detail, sprite scene, setting data, UI from REST API
}

struct ViewControllerStyleModel {
    let title: String
    let style: ViewControllerStyle
}

class DataServiceImpl: DataService {
    func viewControllerStyleList(completion: ([ViewControllerStyleModel]) -> Void) {
        var a = [ViewControllerStyleModel]()

        a.append(ViewControllerStyleModel(title: "Popover", style: .popover))
        a.append(ViewControllerStyleModel(title: "Search", style: .search))
        a.append(ViewControllerStyleModel(title: "Modal alert", style: .modalAlert))
        a.append(ViewControllerStyleModel(title: "Modal celebration", style: .modal))
        a.append(ViewControllerStyleModel(title: "Push map", style: .push))
        a.append(ViewControllerStyleModel(title: "Push with storyboard", style: .pushWithStoryBoard))
        a.append(ViewControllerStyleModel(title: "Toggle loading view controller", style: .childLoading))
        a.append(ViewControllerStyleModel(title: "Send an email", style: .email))
        a.append(ViewControllerStyleModel(title: "View HTML", style: .html))

        completion(a)
    }


}
