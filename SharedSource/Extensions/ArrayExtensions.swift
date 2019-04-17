import Foundation

extension Array {
    mutating func append(ifNotNil element: Element?) {
        if let element = element {
            self.append(element)
        }
    }
}
