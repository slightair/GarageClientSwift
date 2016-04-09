import Foundation
import APIKit
import Result
import Himotoki

class GarageClient {
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
                    handler(Result.Failure(GarageClient.GarageErrorFromAPIError(error)))
                }
            }
    }

    static func GarageErrorFromAPIError(baseError: APIError) -> GarageError {
        switch baseError {
        case .UnacceptableStatusCode(let statusCode, let error as NSError):
            guard let urlResponse = error.userInfo["URLResponse"] as? NSHTTPURLResponse else {
                return .Raw(baseError)
            }

            switch statusCode {
            case 400:
                return .BadRequest(urlResponse)
            default:
                return .Raw(baseError)
            }
        default:
            return .Raw(baseError)
        }
    }
}
