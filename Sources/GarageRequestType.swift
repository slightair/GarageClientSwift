import Foundation
import APIKit

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: [String: AnyObject]? { get }
    var bodyParameters: BodyParametersType? { get }
    var headerFields: [String: String] { get }

    func interceptURLRequest(_ URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public extension GarageRequestParameterContainer {
    public var queryParameters: [String: AnyObject]? {
        return nil
    }

    public var bodyParameters: BodyParametersType? {
        return nil
    }

    public var headerFields: [String: String] {
        return [:]
    }

    public func interceptURLRequest(_ URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return URLRequest
    }
}

public protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
