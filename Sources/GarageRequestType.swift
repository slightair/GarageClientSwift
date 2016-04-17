import Foundation
import APIKit

protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }

    var parameters: [String: AnyObject] { get }
    var objectParameters: AnyObject { get }

    var HTTPHeaderFields: [String: String] { get }

    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest
}

extension GarageRequestParameterContainer {
    var parameters: [String: AnyObject] {
        return [:]
    }

    var objectParameters: AnyObject {
        return []
    }

    var HTTPHeaderFields: [String: String] {
        return [:]
    }

    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        return URLRequest
    }
}

protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
