import Foundation

enum RequestErrors: Error {
    case wrongURL
    case emptyData
}

struct Request {
    let hex: HEX

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: "https://www.thecolorapi.com/id?hex=\(hex)") else {
            throw RequestErrors.wrongURL
        }
        return URLRequest(url: url)
    }
}

let requestProvider = RequestProvider()

final class RequestProvider {
    func sync(_ request: Request) -> Result<Response, Error> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Response, Error>!
        do {
            let urlSession = URLSession(configuration: .default)
            let request = try request.asURLRequest()
            urlSession.dataTask(with: request) { data, _, error in
                defer {
                    semaphore.signal()
                }
                if let error = error {
                    result = .failure(error)
                    return
                }
                guard let data = data else {
                    result = .failure(RequestErrors.emptyData)
                    return
                }
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = try jsonDecoder.decode(Response.self, from: data)
                    result = .success(data)
                } catch {
                    result = .failure(error)
                }
            }
            .resume()
        } catch {
            result = .failure(error)
        }
        semaphore.wait()
        return result
    }
}
