import Foundation
import APIKit

struct WrappedRequest<T: GarageRequestType>: RequestType {
    typealias Response = T.Response

    let baseRequest: T
    let configuration: GarageConfigurationType

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

class RequestBuilder<T: GarageRequestType> {
    static func buildRequest(baseRequest: T, configuration: GarageConfigurationType) ->
        WrappedRequest<T> {
            return WrappedRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
