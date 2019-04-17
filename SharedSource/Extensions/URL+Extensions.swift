import UIKit

extension URLSession {
    open func dataTaskDebug(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        print("\(request.httpMethod ?? "method unspecified") \(request.url?.absoluteString ?? "nil URL")")
        return URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }

}

extension URL {

    init(_ string: String) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("App assumes '\(string)' is a valid URL.")
        }
        self = url
    }
    //  let url = URL(base, ("practitioners",1), ("pets",1))
    init(_ base: String, _ pathPair: (path: String, id: Int?)...) {
        var uri = base
        for pair in pathPair {
            uri += "/\(pair.path)"
            if let id = pair.id {
                uri += "/\(id)"
            }
        }
        self.init(uri)
    }

    init(localFile name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            preconditionFailure("Expected local file: \(name)")
        }
        self.init(fileURLWithPath: path)
    }

    func groupGetData(urls: [URL], completion: @escaping ([Data]) -> Void) {
        let group = DispatchGroup()
        var dataArray = [Data]()
        urls.forEach { url in
            group.enter()
            url.getData { data in
                dataArray.append(ifNotNil: data)
                group.leave()
            }
        }
        group.notify(queue: .main) { [] in
            completion(dataArray)
        }
    }

    func getModel<T: Codable>(type: T.Type, completion: @escaping (T?) -> Void) {
        var req = URLRequest(url: self)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let model: T? = data.decode()
            completion(model)
        }
        dataTask.resume()
    }

    func getData(completion: @escaping (Data?) -> Void) {
        var req = URLRequest(url: self)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }

    func delete(completion: @escaping () -> Void) {
        var req = URLRequest(url: self)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "DELETE"
       let dataTask = URLSession.shared.dataTaskDebug(with: req) { _, _, _ in
            completion()
        }
        dataTask.resume()
    }

    func getResult(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var req = URLRequest(url: self)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, err in
            guard err == nil else { return completion(.failure(.messageError(err!.localizedDescription))) }
            guard let jsonData = data else { return completion(.failure(.noDataError)) }
            return completion(.success(jsonData))
        }
        dataTask.resume()
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        let req = URLRequest(url: self)
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, err in
            guard let data = data, err == nil else { completion(nil); return }
            DispatchQueue.main.async {
                if let image =  UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }

    func putData(data: Data, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var req = URLRequest(url: self)
        req.httpMethod = "PUT"
        req.httpBody = data
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, err in
            // .failure(err!.localizedDescription)
            guard err == nil else { return completion(.failure(.messageError(err!.localizedDescription))) }
            guard let jsonData = data else { return completion(.failure(.noDataError)) }
            return completion(.success(jsonData))
        }
        dataTask.resume()
    }

    func postData(data: Data, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var req = URLRequest(url: self)
        req.httpMethod = "POST"
        req.httpBody = data
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTaskDebug(with: req) { data, _, err in
            // .failure(err!.localizedDescription)
            guard err == nil else { return completion(.failure(.messageError(err!.localizedDescription))) }
            guard let jsonData = data else { return completion(.failure(.noDataError)) }
            return completion(.success(jsonData))
        }
        dataTask.resume()
    }
}
