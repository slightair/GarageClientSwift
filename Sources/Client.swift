import Foundation
import APIKit
import Result
import Himotoki

class Client {
    let configuration: GarageConfigurationType
    var session: Session!

    init(configuration: GarageConfigurationType) {
        self.configuration = configuration

        let urlSession = NSURLSession(configuration: sessionConfiguration(),
                                      delegate: URLSessionDelegate(),
                                      delegateQueue: nil)
        self.session = Session(URLSession: urlSession)
    }

    func sessionConfiguration() -> NSURLSessionConfiguration {
        var headers = configuration.headers
        headers["Authorization"] = "Bearer \(configuration.accessToken)"

        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = headers

        return sessionConfiguration
    }

    func sendRequest<T: GarageRequestType where T.Response: Decodable,
        T.Response == T.Response.DecodedType>
        (request: T, handler: (Result<T.Response, GarageError>) ->
        Void = {result in}) -> NSURLSessionDataTask? {
            let wrappedRequest = RequestBuilder.buildRequest(request, configuration: configuration)
            return session.sendRequest(wrappedRequest) { result in
                switch result {
                case .Success(let result):
                    handler(Result.Success(result))
                case .Failure(let error):
                    let convertedError = self.convertError(error)
                    handler(Result.Failure(convertedError))
                }
            }
    }

    func convertError(baseError: APIError) -> GarageError {
        return .Raw(baseError)
    }
}
