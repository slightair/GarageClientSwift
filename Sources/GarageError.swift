import Foundation

public enum GarageError: ErrorType {
    case ConfigurationError(ErrorType)
    case ConnectionError(NSError)
    case RequestError(ErrorType)
    case InvalidResponse(ErrorType)

    case BadRequest(NSHTTPURLResponse)
    case Unauthorized(NSHTTPURLResponse)
    case Forbidden(NSHTTPURLResponse)
    case NotFound(NSHTTPURLResponse)
    case NotAcceptable(NSHTTPURLResponse)
    case Conflict(NSHTTPURLResponse)
    case UnsupportedMediaType(NSHTTPURLResponse)
    case UnprocessableEntity(NSHTTPURLResponse)
    case InternalServerError(NSHTTPURLResponse)
    case ServiceUnavailable(NSHTTPURLResponse)
    case ClientError(NSHTTPURLResponse)
    case ServerError(NSHTTPURLResponse)

    case Unknown(ErrorType)
}
