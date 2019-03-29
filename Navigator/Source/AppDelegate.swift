import UIKit

var appCoordinator: AppCoordinator!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if isNotUnitTesting() {
            appCoordinator = AppCoordinator(appNavigator: Navigator(), dataService: DataServiceImpl())
            appCoordinator.start()
        }
        return true
    }

    private func isNotUnitTesting() -> Bool {
        if let value = ProcessInfo.processInfo.environment["IS_UNIT_TESTING"] {
            return value != "1"
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}
