import Foundation

extension Array {
    mutating func append(ifNotNil element: Element?) {
        if let element = element {
            self.append(element)
        }
    }
}

extension Array where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}
