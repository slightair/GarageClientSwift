import Foundation
import APIKit

protocol GarageRequestType {
    associatedtype Response

    var method: HTTPMethod { get }
    var path: String { get }

    func responseFromObject(object: AnyObject, urlResponse: NSHTTPURLResponse) -> Response?
}
