import Foundation
import APIKit
import Himotoki

protocol ResourceRequest: Request {
    var baseRequest: GarageRequestParameterContainer { get }
    var configuration: GarageConfiguration { get }
}

extension ResourceRequest {
    var baseURL: URL {
        return configuration.endpoint as URL
    }

    var method: HTTPMethod {
        return baseRequest.method
    }

    var path: String {
        let pathPrefix = configuration.pathPrefix as NSString
        return pathPrefix.appendingPathComponent(baseRequest.path)
    }

    var queryParameters: [String: Any]? {
        return baseRequest.queryParameters
    }

    var bodyParameters: BodyParameters? {
        return baseRequest.bodyParameters
    }

    var headerFields: [String: String] {
        return baseRequest.headerFields
    }

    func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return try baseRequest.intercept(urlRequest: urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            switch urlResponse.statusCode {
            case 400:
                throw GarageError.badRequest(object, urlResponse)
            case 401:
                throw GarageError.unauthorized(object, urlResponse)
            case 403:
                throw GarageError.forbidden(object, urlResponse)
            case 404:
                throw GarageError.notFound(object, urlResponse)
            case 406:
                throw GarageError.notAcceptable(object, urlResponse)
            case 409:
                throw GarageError.conflict(object, urlResponse)
            case 415:
                throw GarageError.unsupportedMediaType(object, urlResponse)
            case 422:
                throw GarageError.unprocessableEntity(object, urlResponse)
            case 500:
                throw GarageError.internalServerError(object, urlResponse)
            case 503:
                throw GarageError.serviceUnavailable(object, urlResponse)
            case 400..<500:
                throw GarageError.clientError(object, urlResponse)
            case 500..<600:
                throw GarageError.serverError(object, urlResponse)
            default:
                throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
            }
        }
        return object
    }

    func headerParameters(from response: HTTPURLResponse) -> (totalCount: Int?, linkHeader: LinkHeader?) {
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

struct SingleResourceRequest<R: GarageRequest, D: Decodable>: ResourceRequest where R.Resource == D {
    typealias Response = GarageResponse<D>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfiguration

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let parameters = headerParameters(from: urlResponse)
        if let rootKeyPath = baseRequest.decodeRootKeyPath {
            guard let resource: D = try? decodeValue(object, rootKeyPath: rootKeyPath) else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        } else {
            guard let resource: D = try? decodeValue(object) else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        }
    }
}

struct MultipleResourceRequest<R: GarageRequest, D: Decodable>: ResourceRequest where R.Resource: Collection, R.Resource.Iterator.Element == D {
    typealias Response = GarageResponse<[D]>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfiguration

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {

        let parameters = headerParameters(from: urlResponse)
        if let rootKeyPath = baseRequest.decodeRootKeyPath {
            guard let resource: [D] = try decodeArray(object, rootKeyPath: rootKeyPath) as [D]? else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        } else {
            guard let resource: [D] = try decodeArray(object) as [D]? else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        }
    }
}

struct RequestBuilder {
    static func buildRequest<R: GarageRequest, D: Decodable>
        (from baseRequest: R, configuration: GarageConfiguration) -> SingleResourceRequest<R, D> where R.Resource == D {
        return SingleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<R: GarageRequest, D: Decodable>
        (from baseRequest: R, configuration: GarageConfiguration) -> MultipleResourceRequest<R, D> where R.Resource: Collection, R.Resource.Iterator.Element == D {
        return MultipleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
