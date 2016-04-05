import Foundation
import APIKit
import Result

class Client {
    let configuration: GarageConfigurationType

    init(configuration: GarageConfigurationType) {
        self.configuration = configuration
    }

    func sendRequest<T: GarageRequestType>(request: T,
                     handler: (Result<T.Response, GarageError>) -> Void = {result in}) ->
        NSURLSessionDataTask? {
            let wrappedRequest = RequestBuilder.buildRequest(request, configuration: configuration)
            return Session.sendRequest(wrappedRequest) { result in
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
