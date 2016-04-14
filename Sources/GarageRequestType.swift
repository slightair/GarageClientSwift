import Foundation
import APIKit

protocol GarageRequestType {
    associatedtype Resource

    var method: HTTPMethod { get }
    var path: String { get }
}
