import Foundation
import APIKit
import Himotoki

struct WrappedRequest<T: GarageRequestType where T.Response: Decodable,
    T.Response == T.Response.DecodedType>: RequestType {
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
        let pathPrefix = configuration.pathPrefix as NSString
        return pathPrefix.stringByAppendingPathComponent(baseRequest.path)
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        return try? decodeValue(object)
    }
}

class RequestBuilder<T: GarageRequestType where T.Response: Decodable,
    T.Response == T.Response.DecodedType> {
    static func buildRequest(baseRequest: T, configuration: GarageConfigurationType) ->
        WrappedRequest<T> {
            return WrappedRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
