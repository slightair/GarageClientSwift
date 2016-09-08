import Foundation

public enum GarageError: Error {
    case badRequest(AnyObject, HTTPURLResponse)
    case unauthorized(AnyObject, HTTPURLResponse)
    case forbidden(AnyObject, HTTPURLResponse)
    case notFound(AnyObject, HTTPURLResponse)
    case notAcceptable(AnyObject, HTTPURLResponse)
    case conflict(AnyObject, HTTPURLResponse)
    case unsupportedMediaType(AnyObject, HTTPURLResponse)
    case unprocessableEntity(AnyObject, HTTPURLResponse)
    case internalServerError(AnyObject, HTTPURLResponse)
    case serviceUnavailable(AnyObject, HTTPURLResponse)
    case clientError(AnyObject, HTTPURLResponse)
    case serverError(AnyObject, HTTPURLResponse)
}
