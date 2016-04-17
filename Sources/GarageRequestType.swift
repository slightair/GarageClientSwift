import Foundation
import APIKit

protocol GarageRequestParameterContainer {
    var method: HTTPMethod { get }
    var path: String { get }
}

protocol GarageRequestType: GarageRequestParameterContainer {
    associatedtype Resource
}
