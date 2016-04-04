import Foundation
import APIKit
import Result

class Client {
    let configuration: ClientConfigurationType

    init(configuration: ClientConfigurationType) {
        self.configuration = configuration
    }

    func sendRequest<T: ClientRequestType>(request: T,
                     handler: (Result<T.Response, ClientError>) -> Void = {result in}) ->
        NSURLSessionDataTask? {
            return nil
    }
}
