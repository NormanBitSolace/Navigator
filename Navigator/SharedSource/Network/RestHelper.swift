import Foundation

protocol RestHelper { }

extension RestHelper {

    func get<T: Codable>(type: T.Type, url: URL, completion: @escaping (T?) -> Void) {
        url.getData { result in
            completion(result?.decode())
        }
    }

    func post<T: Codable>(model: T, url: URL, completion: ((T?) -> Void)?) {
        guard let data = model.encode() else {
            completion?(nil)
            return
        }
        url.postData(data: data) { result in
            completion?(result.decode())
        }
    }

    func put<T: Codable>(model: T, url: URL, completion: ((T?) -> Void)?) {
        guard let data = model.encode() else {
            completion?(nil)
            return
        }
        url.putData(data: data) { result in
            completion?(result.decode())
        }
    }

    func delete(url: URL, completion: (() -> Void)?) {
        url.delete {
            completion?()
        }
    }
}
