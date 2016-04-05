import Foundation
import APIKit

protocol ClientRequestType {
    associatedtype Response

    var method: HTTPMethod { get }
    var path: String { get }
}
