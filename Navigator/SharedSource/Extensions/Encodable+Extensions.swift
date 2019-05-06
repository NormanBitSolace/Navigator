import Foundation

extension Encodable {

    var jsonString: String? {
        return encode(isPretty: true)?.asString
    }
    func encode(isPretty: Bool = false) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            if isPretty {
                encoder.outputFormatting = .prettyPrinted
            }
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
