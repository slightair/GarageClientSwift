import Foundation
import APIKit
import Himotoki

protocol ResourceRequest: RequestType {
    var baseRequest: GarageRequestParameterContainer { get }
    var configuration: GarageConfigurationType { get }
}

extension ResourceRequest {
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

struct SingleResourceRequest<R: GarageRequestType, D: Decodable where R.Resource == D>: ResourceRequest {
    typealias Response = GarageResponse<D>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfigurationType

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let resource: D = try? decodeValue(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct MultipleResourceRequest<R: GarageRequestType, D: Decodable where R.Resource: CollectionType, R.Resource.Generator.Element == D>: ResourceRequest {
    typealias Response = GarageResponse<[D]>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfigurationType

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let resource: [D] = try? decodeArray(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct RequestBuilder {
    static func buildRequest<R: GarageRequestType, D: Decodable where R.Resource == D>
        (baseRequest: R, configuration: GarageConfigurationType) -> SingleResourceRequest<R, D> {
        return SingleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<R: GarageRequestType, D: Decodable where R.Resource: CollectionType, R.Resource.Generator.Element == D>
        (baseRequest: R, configuration: GarageConfigurationType) -> MultipleResourceRequest<R, D> {
        return MultipleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
