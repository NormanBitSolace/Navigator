import UIKit

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

//  Int for .rawValue, CaseIterable for ScreenType.allCases
public enum ScreenType : Int, CaseIterable {
    case phone320by480
    case phone320by568 // includes 5th & 6h gen iPod Touch
    case phone375by667
    case phone414by736
    case phone375by812
    case phone414by896
    case pad768by1024
    case pad834by1112
    case pad1024by1366
}

extension ScreenType {
    static var current: ScreenType {
        switch ScreenSize.SCREEN_MAX_LENGTH {
        case 480:
            return .phone320by480
        case 568:
            return .phone320by568
        case 667:
            return .phone375by667
        case 736:
            return .phone414by736
        case 812:
            return .phone375by812
        case 896:
            return .phone414by896
        case 1024:
            return .pad768by1024
        case 1112:
            return .pad834by1112
        case 1366:
            return .pad1024by1366
        default:
            //  some unrecognized future screen size, take best guess
            let area = ScreenSize.SCREEN_WIDTH * ScreenSize.SCREEN_HEIGHT
            var diff = CGFloat.greatestFiniteMagnitude
            var screenType = ScreenType.phone375by812
            for currentScreenType in ScreenType.allCases {
                let size = ScreenType.size(forScreenType: currentScreenType)
                let currArea = size.width * size.height
                let currDiff = abs(area - currArea)
                if currDiff < diff {
                    diff = currDiff
                    screenType = currentScreenType
                }
            }
            return screenType
        }
    }

    static func size(forScreenType screenType: ScreenType) -> CGSize {
        switch screenType {
        case .phone320by480: return CGSize(width: 320, height: 480)
        case .phone320by568: return CGSize(width: 320, height: 568)
        case .phone375by667: return CGSize(width: 375, height: 667)
        case .phone414by736: return CGSize(width: 414, height: 736)
        case .phone375by812: return CGSize(width: 375, height: 812)
        case .phone414by896: return CGSize(width: 414, height: 896)
        case .pad768by1024: return CGSize(width: 768, height: 1024)
        case .pad834by1112: return CGSize(width: 834, height: 1112)
        case .pad1024by1366: return CGSize(width: 1024, height: 1366)
        }
     }

    static func landscapeSize(forScreenType screenType: ScreenType) -> CGSize {
        let s = ScreenType.size(forScreenType: screenType)
        return CGSize(width: s.height, height: s.width)
    }
}

public extension UIDevice {
    
    static let modelName: String = UIDevice.current.modelName
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isSimulator = "Simulator" == UIDevice.modelName
    static var screenType = ScreenType.current
    static let size = ScreenType.size(forScreenType: screenType)
    static let landscapeSize = ScreenType.landscapeSize(forScreenType: screenType)

    var isPortrait: Bool { return UIApplication.shared.statusBarOrientation.isPortrait }
    var orientationSize: CGSize { return isPortrait ? UIDevice.size : UIDevice.landscapeSize }

    //  access with stored UIDevice.modelName
    fileprivate var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = (element.value as? Int8), value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad7,5", "iPad7,6":                      return "iPad 6th Generation"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 1st Generation"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 2nd Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5"
        case "AppleTV2,1":                              return "Apple TV 2nd Generation"
        case "AppleTV3,1", "AppleTV3,2":                return "Apple TV 3rd Generation"
        case "AppleTV5,3":                              return "Apple TV 4th Generation"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

public extension UIDevice {
    static let isPhonePlus = screenType == ScreenType.phone414by736
    static let hasCutout = (screenType == .phone375by812) || (screenType == .phone414by896)
}
