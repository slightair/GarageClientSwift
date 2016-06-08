import Foundation
import APIKit
import Result
import Himotoki

public class GarageClient {
    public let configuration: GarageConfigurationType
    public var session: Session!

    public init(configuration: GarageConfigurationType) {
        self.configuration = configuration

        let adapter = NSURLSessionAdapter(configuration: sessionConfiguration())
        self.session = Session(adapter: adapter)
    }

    func sessionConfiguration() -> NSURLSessionConfiguration {
        var headers = configuration.headers
        headers["Authorization"] = "Bearer \(configuration.accessToken)"

        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = headers

        return sessionConfiguration
    }

    public func sendRequest<R: GarageRequestType, D: Decodable where R.Resource == D>
        (request: R, handler: (Result<GarageResponse<D>, SessionTaskError>) -> Void = { result in }) -> SessionTaskType? {
        let resourceRequest = RequestBuilder.buildRequest(request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .Success(let result):
                handler(.Success(result))
            case .Failure(let error):
                handler(.Failure(error))
            }
        }
    }

    public func sendRequest<R: GarageRequestType, D: Decodable where R.Resource: CollectionType, R.Resource.Generator.Element == D>
        (request: R, handler: (Result<GarageResponse<[D]>, SessionTaskError>) -> Void = { result in }) -> SessionTaskType? {
        let resourceRequest = RequestBuilder.buildRequest(request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .Success(let result):
                handler(.Success(result))
            case .Failure(let error):
                handler(.Failure(error))
            }
        }
    }
}
