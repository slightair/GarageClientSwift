import Foundation

public enum GarageError: ErrorType {
    case ConfigurationError(ErrorType)
    case ConnectionError(NSError)
    case RequestError(ErrorType)
    case InvalidResponse(ErrorType)

    case BadRequest(AnyObject, NSHTTPURLResponse)
    case Unauthorized(AnyObject, NSHTTPURLResponse)
    case Forbidden(AnyObject, NSHTTPURLResponse)
    case NotFound(AnyObject, NSHTTPURLResponse)
    case NotAcceptable(AnyObject, NSHTTPURLResponse)
    case Conflict(AnyObject, NSHTTPURLResponse)
    case UnsupportedMediaType(AnyObject, NSHTTPURLResponse)
    case UnprocessableEntity(AnyObject, NSHTTPURLResponse)
    case InternalServerError(AnyObject, NSHTTPURLResponse)
    case ServiceUnavailable(AnyObject, NSHTTPURLResponse)
    case ClientError(AnyObject, NSHTTPURLResponse)
    case ServerError(AnyObject, NSHTTPURLResponse)

    case Unknown(ErrorType)
}
