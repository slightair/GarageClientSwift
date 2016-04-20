import Foundation
import APIKit

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }

    var parameters: [String: AnyObject] { get }
    var objectParameters: AnyObject { get }

    var HTTPHeaderFields: [String: String] { get }

    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public extension GarageRequestParameterContainer {
    public var parameters: [String: AnyObject] {
        return [:]
    }

    public var objectParameters: AnyObject {
        return []
    }

    public var HTTPHeaderFields: [String: String] {
        return [:]
    }

    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return URLRequest
    }
}

public protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
