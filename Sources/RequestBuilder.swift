import Foundation
import APIKit

struct WrappedRequest<T: ClientRequestType>: RequestType {
    typealias Response = T.Response

    let baseRequest: T
    let configuration: ClientConfigurationType

    var baseURL: NSURL {
        return configuration.endpoint
    }

    var method: HTTPMethod {
        return baseRequest.method
    }

    var path: String {
        return [configuration.pathPrefix, baseRequest.path].joinWithSeparator("/")
    }

    func responseFromObject(object: AnyObject, URLResponse urlResponse: NSHTTPURLResponse) ->
        Response? {
        return baseRequest.responseFromObject(object, urlResponse: urlResponse)
    }
}

class RequestBuilder<T: ClientRequestType> {
    static func buildRequest(baseRequest: T, configuration: ClientConfigurationType) ->
        WrappedRequest<T> {
            return WrappedRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
