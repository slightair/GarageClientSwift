import Foundation
import APIKit
import Result
import Himotoki

public class GarageClient {
    public let configuration: GarageConfigurationType
    public var session: Session!

    public init(configuration: GarageConfigurationType) {
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

    public func sendRequest<R: GarageRequestType, D: Decodable where R.Resource == D>
        (request: R, handler: (Result<GarageResponse<D>, GarageError>) -> Void = {result in}) -> NSURLSessionDataTask? {
        let resourceRequest = RequestBuilder.buildRequest(request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .Success(let result):
                handler(Result.Success(result))
            case .Failure(let error):
                handler(Result.Failure(GarageClient.GarageErrorFromAPIError(error)))
            }
        }
    }

    public func sendRequest<R: GarageRequestType, D: Decodable where R.Resource: CollectionType, R.Resource.Generator.Element == D>
        (request: R, handler: (Result<GarageResponse<[D]>, GarageError>) -> Void = {result in}) -> NSURLSessionDataTask? {
        let resourceRequest = RequestBuilder.buildRequest(request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .Success(let result):
                handler(Result.Success(result))
            case .Failure(let error):
                handler(Result.Failure(GarageClient.GarageErrorFromAPIError(error)))
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func GarageErrorFromAPIError(baseError: APIError) -> GarageError {
        switch baseError {
        case .ConnectionError(let error):
            return .ConnectionError(error)
        case .InvalidBaseURL, .ConfigurationError:
            return .ConfigurationError(baseError)
        case .RequestBodySerializationError:
            return .RequestError(baseError)
        case .ResponseBodyDeserializationError, .InvalidResponseStructure, .NotHTTPURLResponse:
            return .InvalidResponse(baseError)
        case .UnacceptableStatusCode(let statusCode, let error as NSError):
            guard let urlResponse = error.userInfo["URLResponse"] as? NSHTTPURLResponse else {
                return .Unknown(baseError)
            }

            switch statusCode {
            case 400:
                return .BadRequest(urlResponse)
            case 401:
                return .Unauthorized(urlResponse)
            case 403:
                return .Forbidden(urlResponse)
            case 404:
                return .NotFound(urlResponse)
            case 406:
                return .NotAcceptable(urlResponse)
            case 409:
                return .Conflict(urlResponse)
            case 415:
                return .UnsupportedMediaType(urlResponse)
            case 422:
                return .UnprocessableEntity(urlResponse)
            case 500:
                return .InternalServerError(urlResponse)
            case 503:
                return .ServiceUnavailable(urlResponse)
            case 400..<500:
                return .ClientError(urlResponse)
            case 500..<600:
                return .ServerError(urlResponse)
            default:
                return .Unknown(baseError)
            }
        default:
            return .Unknown(baseError)
        }
    }
}
