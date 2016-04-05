import Foundation
import APIKit

protocol GarageRequestType {
    associatedtype Response

    var method: HTTPMethod { get }
    var path: String { get }
}
