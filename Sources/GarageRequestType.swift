import Foundation
import APIKit

public protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: AnyObject? { get }
    var headerFields: [String: String] { get }

    func interceptURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

public extension GarageRequestParameterContainer {
    public var parameters: AnyObject? {
        return nil
    }

    public var headerFields: [String: String] {
        return [:]
    }

    public func interceptURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return URLRequest
    }
}

public protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
