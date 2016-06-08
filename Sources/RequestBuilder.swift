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

    var parameters: AnyObject? {
        return baseRequest.parameters
    }

    var headerFields: [String: String] {
        return baseRequest.headerFields
    }

    func interceptURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return try baseRequest.interceptURLRequest(URLRequest)
    }

    func interceptObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> AnyObject {
        guard (200..<300).contains(URLResponse.statusCode) else {
            switch URLResponse.statusCode {
            case 400:
                throw GarageError.BadRequest(object, URLResponse)
            case 401:
                throw GarageError.Unauthorized(object, URLResponse)
            case 403:
                throw GarageError.Forbidden(object, URLResponse)
            case 404:
                throw GarageError.NotFound(object, URLResponse)
            case 406:
                throw GarageError.NotAcceptable(object, URLResponse)
            case 409:
                throw GarageError.Conflict(object, URLResponse)
            case 415:
                throw GarageError.UnsupportedMediaType(object, URLResponse)
            case 422:
                throw GarageError.UnprocessableEntity(object, URLResponse)
            case 500:
                throw GarageError.InternalServerError(object, URLResponse)
            case 503:
                throw GarageError.ServiceUnavailable(object, URLResponse)
            case 400..<500:
                throw GarageError.ClientError(object, URLResponse)
            case 500..<600:
                throw GarageError.ServerError(object, URLResponse)
            default:
                throw ResponseError.UnacceptableStatusCode(URLResponse.statusCode)
            }
        }
        return object
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

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let resource: D = try? decodeValue(object) else {
            throw ResponseError.UnexpectedObject(object)
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct MultipleResourceRequest<R: GarageRequestType, D: Decodable where R.Resource: CollectionType, R.Resource.Generator.Element == D>: ResourceRequest {
    typealias Response = GarageResponse<[D]>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfigurationType

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let resource: [D] = try? decodeArray(object) else {
            throw ResponseError.UnexpectedObject(object)
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
