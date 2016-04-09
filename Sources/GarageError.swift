import Foundation

public enum GarageError: ErrorType {
    case BadRequest(NSHTTPURLResponse)
    case Unauthorized(NSHTTPURLResponse)
    case Forbidden(NSHTTPURLResponse)
    case NotFound(NSHTTPURLResponse)
    case NotAcceptable(NSHTTPURLResponse)
    case Conflict(NSHTTPURLResponse)
    case UnsupportedMediaType(NSHTTPURLResponse)
    case UnprocessableEntity(NSHTTPURLResponse)
    case ClientError(NSHTTPURLResponse)
    case ServerError(NSHTTPURLResponse)

    case InternalServerError(NSHTTPURLResponse)
    case ServiceUnavailable(NSHTTPURLResponse)

    case UnsupportedResource
    case InvalidResponseType

    case Raw(ErrorType)
}

public func == (a: GarageError, b: GarageError) -> Bool {
    switch (a, b) {
    case (.BadRequest(let responseA), .BadRequest(let responseB))
        where responseA == responseB: return true
    case (.Unauthorized(let responseA), .Unauthorized(let responseB))
        where responseA == responseB: return true
    case (.Forbidden(let responseA), .Forbidden(let responseB))
        where responseA == responseB: return true
    case (.NotFound(let responseA), .NotFound(let responseB))
        where responseA == responseB: return true
    case (.NotAcceptable(let responseA), .NotAcceptable(let responseB))
        where responseA == responseB: return true
    case (.Conflict(let responseA), .Conflict(let responseB))
        where responseA == responseB: return true
    case (.UnsupportedMediaType(let responseA), .UnsupportedMediaType(let responseB))
        where responseA == responseB: return true
    case (.UnprocessableEntity(let responseA), .UnprocessableEntity(let responseB))
        where responseA == responseB: return true
    case (.ClientError(let responseA), .ClientError(let responseB))
        where responseA == responseB: return true
    case (.ServerError(let responseA), .ServerError(let responseB))
        where responseA == responseB: return true
    case (.InternalServerError(let responseA), .InternalServerError(let responseB))
        where responseA == responseB: return true
    case (.ServiceUnavailable(let responseA), .ServiceUnavailable(let responseB))
        where responseA == responseB: return true
    case (.UnsupportedResource, .UnsupportedResource): return true
    case (.InvalidResponseType, .InvalidResponseType): return true
    case (.Raw(_), .Raw(_)): return true // imperfection
    default:
        return false
    }
}
