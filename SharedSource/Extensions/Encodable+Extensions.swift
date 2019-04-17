import Foundation

extension Encodable {

    func encode() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
