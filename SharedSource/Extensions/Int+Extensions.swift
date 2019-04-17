import Foundation

extension Int {
    var spellOut: String {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue) ?? "42"
    }
}
