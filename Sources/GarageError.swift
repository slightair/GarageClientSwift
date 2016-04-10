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
