import UIKit

extension Data {

    var asString: String { return String(decoding: self, as: UTF8.self) }

    func decode<T: Codable>() -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let resource = try decoder.decode(T.self, from: self)
            return resource

        } catch {
            print(self.asString)
            print(error.localizedDescription)
        }
        return nil
    }

    init(localFile name: String) {
        let url = URL(localFile: name)
        do {
            try self.init(contentsOf: url)
        } catch {
            preconditionFailure("Expected local file named: \(name).")
        }
    }

    func animationImages() -> [UIImage]? {
        if let imageSource = CGImageSourceCreateWithData(self as CFData, nil) {
            return (0..<CGImageSourceGetCount(imageSource)).compactMap {  CGImageSourceCreateImageAtIndex(imageSource, $0, nil)

                }.map { UIImage(cgImage: $0) }
        }
        return nil
    }
}
