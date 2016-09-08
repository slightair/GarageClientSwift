import Foundation
import APIKit

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: BodyParametersType? { get }
    var headerFields: [String: String] { get }

    func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public extension GarageRequestParameterContainer {
    public var queryParameters: [String: Any]? {
        return nil
    }

    public var bodyParameters: BodyParametersType? {
        return nil
    }

    public var headerFields: [String: String] {
        return [:]
    }

    public func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return urlRequest
    }
}

public protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
