import Foundation

enum NetworkError: Error {
    case noDataError
    case unknownError
    case messageError(String)
}
