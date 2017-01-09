import Foundation
import APIKit
import Himotoki

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
    var decodeRootKeyPath: KeyPath? { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: BodyParameters? { get }
    var headerFields: [String: String] { get }

    func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public extension GarageRequestParameterContainer {

    public var rootKeyPath: [String]? {
        return nil
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var bodyParameters: BodyParameters? {
        return nil
    }

    public var headerFields: [String: String] {
        return [:]
    }

    public func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return urlRequest
    }
}

public protocol GarageRequest: GarageRequestParameterContainer {
    associatedtype Resource
}
