import Foundation
import APIKit
import Result
import Himotoki

open class GarageClient {
    open let configuration: GarageConfigurationType
    open var session: Session!

    public init(configuration: GarageConfigurationType) {
        self.configuration = configuration

        let adapter = URLSessionAdapter(configuration: sessionConfiguration())
        self.session = Session(adapter: adapter)
    }

    func sessionConfiguration() -> URLSessionConfiguration {
        var headers = configuration.headers
        headers["Authorization"] = "Bearer \(configuration.accessToken)"

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = headers

        return sessionConfiguration
    }

    open func sendRequest<R: GarageRequestType, D: Decodable>
        (_ request: R, handler: @escaping (Result<GarageResponse<D>, SessionTaskError>) -> Void = { result in }) -> SessionTaskType? where R.Resource == D {
        let resourceRequest = RequestBuilder.buildRequest(from: request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .success(let result):
                handler(.success(result))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    open func sendRequest<R: GarageRequestType, D: Decodable>
        (_ request: R, handler: @escaping (Result<GarageResponse<[D]>, SessionTaskError>) -> Void = { result in }) -> SessionTaskType? where R.Resource: Collection, R.Resource.Iterator.Element == D {
        let resourceRequest = RequestBuilder.buildRequest(from: request, configuration: configuration)
        return session.sendRequest(resourceRequest) { result in
            switch result {
            case .success(let result):
                handler(.success(result))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
