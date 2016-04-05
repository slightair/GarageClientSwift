import Foundation
import APIKit
import Result
import Himotoki

class Client {
    let configuration: GarageConfigurationType

    init(configuration: GarageConfigurationType) {
        self.configuration = configuration
    }

    func sendRequest<T: GarageRequestType where T.Response: Decodable,
        T.Response == T.Response.DecodedType>
        (request: T, handler: (Result<T.Response, GarageError>) ->
        Void = {result in}) -> NSURLSessionDataTask? {
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
