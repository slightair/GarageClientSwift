import Foundation
import APIKit
import Himotoki

protocol ResourceRequest: RequestType {
    var baseRequest: GarageRequestParameterContainer { get }
    var configuration: GarageConfigurationType { get }
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

    var queryParameters: [String: AnyObject]? {
        return baseRequest.queryParameters
    }

    var bodyParameters: BodyParametersType? {
        return baseRequest.bodyParameters
    }

    var headerFields: [String: String] {
        return baseRequest.headerFields
    }

    func interceptURLRequest(_ URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return try baseRequest.interceptURLRequest(URLRequest)
    }

    func interceptObject(_ object: AnyObject, URLResponse: HTTPURLResponse) throws -> AnyObject {
        guard (200..<300).contains(URLResponse.statusCode) else {
            switch URLResponse.statusCode {
            case 400:
                throw GarageError.badRequest(object, URLResponse)
            case 401:
                throw GarageError.unauthorized(object, URLResponse)
            case 403:
                throw GarageError.forbidden(object, URLResponse)
            case 404:
                throw GarageError.notFound(object, URLResponse)
            case 406:
                throw GarageError.notAcceptable(object, URLResponse)
            case 409:
                throw GarageError.conflict(object, URLResponse)
            case 415:
                throw GarageError.unsupportedMediaType(object, URLResponse)
            case 422:
                throw GarageError.unprocessableEntity(object, URLResponse)
            case 500:
                throw GarageError.internalServerError(object, URLResponse)
            case 503:
                throw GarageError.serviceUnavailable(object, URLResponse)
            case 400..<500:
                throw GarageError.clientError(object, URLResponse)
            case 500..<600:
                throw GarageError.serverError(object, URLResponse)
            default:
                throw ResponseError.UnacceptableStatusCode(URLResponse.statusCode)
            }
        }
        return object
    }

    func headerParameters(_ response: HTTPURLResponse) -> (totalCount: Int?, linkHeader: LinkHeader?) {
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

struct SingleResourceRequest<R: GarageRequestType, D: Decodable>: ResourceRequest where R.Resource == D {
    typealias Response = GarageResponse<D>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfigurationType

    func responseFromObject(_ object: AnyObject, URLResponse: HTTPURLResponse) throws -> Response {
        guard let resource: D = try? decodeValue(object) else {
            throw ResponseError.UnexpectedObject(object)
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct MultipleResourceRequest<R: GarageRequestType, D: Decodable>: ResourceRequest where R.Resource: Collection, R.Resource.Iterator.Element == D {
    typealias Response = GarageResponse<[D]>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfigurationType

    func responseFromObject(_ object: AnyObject, URLResponse: HTTPURLResponse) throws -> Response {
        guard let resource: [D] = try! decodeArray(object) as [D]? else {
            throw ResponseError.UnexpectedObject(object)
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct RequestBuilder {
    static func buildRequest<R: GarageRequestType, D: Decodable>
        (_ baseRequest: R, configuration: GarageConfigurationType) -> SingleResourceRequest<R, D> where R.Resource == D {
        return SingleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<R: GarageRequestType, D: Decodable>
        (_ baseRequest: R, configuration: GarageConfigurationType) -> MultipleResourceRequest<R, D> where R.Resource: Collection, R.Resource.Iterator.Element == D {
        return MultipleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
