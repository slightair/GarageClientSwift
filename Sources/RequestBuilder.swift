import Foundation
import APIKit
import Himotoki

struct SingleResourceRequest<T: GarageRequestType where T.Resource: Decodable>: RequestType {
    typealias Response = GarageResponse<T.Resource>

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

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> GarageResponse<T.Resource>? {
        guard let resource: T.Resource = try? decodeValue(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource,
                              totalCount: parameters.totalCount,
                              linkHeader: parameters.linkHeader)
    }

    func headerParameters(response: NSHTTPURLResponse) -> (totalCount: Int?, linkHeader: LinkHeader?) {
        let totalCount: Int?
        if let totalCountString = response.allHeaderFields["X-List-Totalcount"] as? String {
            totalCount = Int(totalCountString)
        } else {
            totalCount = nil
        }

        let linkHeader: LinkHeader?
        if let linkHeaderString = response.allHeaderFields["Link"] as? String {
            linkHeader = LinkHeader(string: linkHeaderString)
        } else {
            linkHeader = nil
        }

        return (totalCount, linkHeader)
    }
}

struct MultipleResourceRequest<T: GarageRequestType, R: Decodable
    where T.Resource: CollectionType, T.Resource.Generator.Element == R>: RequestType {
    typealias Response = GarageResponse<[R]>

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
        guard let resource: [R] = try? decodeArray(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource,
                              totalCount: parameters.totalCount,
                              linkHeader: parameters.linkHeader)
    }

    func headerParameters(response: NSHTTPURLResponse) -> (totalCount: Int?, linkHeader: LinkHeader?) {
        let totalCount: Int?
        if let totalCountString = response.allHeaderFields["X-List-Totalcount"] as? String {
            totalCount = Int(totalCountString)
        } else {
            totalCount = nil
        }

        let linkHeader: LinkHeader?
        if let linkHeaderString = response.allHeaderFields["Link"] as? String {
            linkHeader = LinkHeader(string: linkHeaderString)
        } else {
            linkHeader = nil
        }

        return (totalCount, linkHeader)
    }
}

struct RequestBuilder {
    static func buildRequest<T: GarageRequestType where T.Resource: Decodable>
        (baseRequest: T, configuration: GarageConfigurationType) -> SingleResourceRequest<T> {
        return SingleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<T: GarageRequestType where T.Resource: CollectionType, T.Resource.Generator.Element: Decodable>
        (baseRequest: T, configuration: GarageConfigurationType) -> MultipleResourceRequest<T, T.Resource.Generator.Element> {
        return MultipleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
