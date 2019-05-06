import Foundation

extension String {
    static func lines(localFile: String) -> [String]? {
        let data = Data(localFile: localFile)
        let fileContents = String(decoding: data, as: UTF8.self)
        let lines = fileContents.components(separatedBy: CharacterSet.newlines).filter { $0.count > 0 }
        return lines.compactMap { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    }
}
