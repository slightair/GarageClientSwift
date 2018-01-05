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

        // Convert the header key to lowercase, because allHeaderFields is case-sensitive by Swift bugs.
        // https://bugs.swift.org/plugins/servlet/mobile#issue/SR-2429
        let keyValues: [String: Any] = response.allHeaderFields.reduce(into: [:]) { $0[String(describing: $1.key).lowercased()] = $1.value}

        let totalCount: Int?
        if let totalCountString = keyValues["x-list-totalcount"] as? String {
            totalCount = Int(totalCountString)
        } else {
            totalCount = nil
        }

        let linkHeader: LinkHeader?
        if let linkHeaderString = keyValues["link"] as? String {
            linkHeader = LinkHeader(string: linkHeaderString)
        } else {
            linkHeader = nil
        }

        return (totalCount, linkHeader)
    }
}

struct CodableParser<D: Swift.Decodable> : DataParser {

    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {

        guard let resource = try? JSONDecoder().decode(D.self, from: data)  else {
            throw ResponseError.unexpectedObject(data)
        }
        return resource
    }
}

struct SingleResourceRequest<R: GarageRequest, D: Himotoki.Decodable>: ResourceRequest where R.Resource == D {
    typealias Response = GarageResponse<D>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfiguration

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let parameters = headerParameters(from: urlResponse)

        if let decodeResponseOption = baseRequest as? GarageDecodeResponseOption, let rootKeyPath = decodeResponseOption.decodeRootKeyPath {
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

struct MultipleResourceRequest<R: GarageRequest, D: Himotoki.Decodable>: ResourceRequest where R.Resource: Collection, R.Resource.Iterator.Element == D {
    typealias Response = GarageResponse<[D]>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfiguration

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let parameters = headerParameters(from: urlResponse)

        if let decodeResponseOption = baseRequest as? GarageDecodeResponseOption, let rootKeyPath = decodeResponseOption.decodeRootKeyPath {
            guard let resource: [D] = try? decodeArray(object, rootKeyPath: rootKeyPath) else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        } else {
            guard let resource: [D] = try? decodeArray(object) else {
                throw ResponseError.unexpectedObject(object)
            }
            return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
        }
    }
}

struct CodableResourceRequest<R: GarageRequest, D: Swift.Decodable>: ResourceRequest where R.Resource == D {

    typealias Response = GarageResponse<D>

    let baseRequest: GarageRequestParameterContainer
    let configuration: GarageConfiguration
    var dataParser: DataParser {
        return CodableParser<R.Resource>()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GarageResponse<D> {

        let parameters = headerParameters(from: urlResponse)
        guard let resource = object as? D else {
            throw ResponseError.unexpectedObject(object)
        }
        return GarageResponse(resource: resource, totalCount: parameters.totalCount, linkHeader: parameters.linkHeader)
    }
}

struct RequestBuilder {
    static func buildRequest<R: GarageRequest, D: Himotoki.Decodable>
        (from baseRequest: R, configuration: GarageConfiguration) -> SingleResourceRequest<R, D> {
        return SingleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<R: GarageRequest, D: Himotoki.Decodable>
        (from baseRequest: R, configuration: GarageConfiguration) -> MultipleResourceRequest<R, D> where R.Resource: Collection {
        return MultipleResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<R: GarageRequest, D: Swift.Decodable>
        (from baseRequest: R, configuration: GarageConfiguration) -> CodableResourceRequest<R, D> {
        return CodableResourceRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
