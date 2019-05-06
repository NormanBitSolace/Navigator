import UIKit

protocol AppMetricsData {
    static var landscapeMetrics: [String : Array<Int>] { get }
    static var portraitMetrics: [String : Array<Int>] { get }
}

class Metric {
    
    fileprivate static let index = UIDevice.screenType.rawValue
    fileprivate static let numScreenTypes = ScreenType.allCases.count
    fileprivate static var landscapeMetrics = AppMetrics.landscapeMetrics
    fileprivate static var portraitMetrics = AppMetrics.portraitMetrics

    internal static func resolve<T>(_ key: String, _ dict: [String : Array<T>]) -> T {
        if let a = dict[key] {
            guard a.count == numScreenTypes else {
                fatalError("Metric.resolve key \(key) only has \(a.count) elements, it requries \(numScreenTypes).")
            }
            return a[Metric.index]
        }
        fatalError("Metric definitions do not contain key \(key)")
    }


    static func int(_ key: String) -> Int {
        //        let isPortrait = UIDevice.current.orientation.isPortrait returns .unknown in XCTest
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait

        if isPortrait {
            if (portraitMetrics[key] != nil) {
                return resolve(key, portraitMetrics)
            }
        }
        return resolve(key, landscapeMetrics)
    }
   static func intf(_ key: String) -> CGFloat {
        let i = Metric.int(key)
        return CGFloat(i)
    }

    static func ints(_ key: String) -> String {
        let i = Metric.int(key)
        return "\(i)"
    }
}
