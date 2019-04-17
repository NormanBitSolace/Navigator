import Foundation

struct RestPath {
    let path: String
    let value: String?
}

extension RestPath {
    init(_ path: String, _ value: String? = nil) {
        self.path = path
        self.value = value == nil ? nil : value
    }

    init(_ path: String, _ value: Int) {
        self.init(path, "\(value)")
    }

    init(_ path: String) {
        self.path = path
        self.value = nil
    }

    func component() -> String {
        var uri = ""
        uri += "/\(path)"
        if let value = value {
            uri += "/\(value)"
        }
        return uri
    }
}

extension RestPath {
    static func + (lhs: RestPath, rhs: RestPath) -> String {
        return lhs.component() + rhs.component()
    }
}

extension URL {
    init(_ base: String, _ components: RestPath...) {
        let uri = base + components.flatMap { $0.component() }
        self.init(uri)
    }
}
