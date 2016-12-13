import Foundation

public enum GarageError: Error {
    case badRequest(Any, HTTPURLResponse)
    case unauthorized(Any, HTTPURLResponse)
    case forbidden(Any, HTTPURLResponse)
    case notFound(Any, HTTPURLResponse)
    case notAcceptable(Any, HTTPURLResponse)
    case conflict(Any, HTTPURLResponse)
    case unsupportedMediaType(Any, HTTPURLResponse)
    case unprocessableEntity(Any, HTTPURLResponse)
    case internalServerError(Any, HTTPURLResponse)
    case serviceUnavailable(Any, HTTPURLResponse)
    case clientError(Any, HTTPURLResponse)
    case serverError(Any, HTTPURLResponse)
}
