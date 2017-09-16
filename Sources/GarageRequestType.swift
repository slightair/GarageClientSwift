import Foundation
import APIKit
import Himotoki

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: BodyParameters? { get }
    var headerFields: [String: String] { get }

    func intercept(urlRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public protocol GarageDecodeResponseOption {
    var decodeRootKeyPath: Himotoki.KeyPath? { get }
}

public extension GarageRequestParameterContainer {
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

public extension GarageDecodeResponseOption {
    public var decodeRootKeyPath: Himotoki.KeyPath? {
        return nil
    }
}

public protocol GarageRequest: GarageRequestParameterContainer, GarageDecodeResponseOption {
    associatedtype Resource
}
