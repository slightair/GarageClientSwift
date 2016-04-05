import Foundation

public enum ClientError: ErrorType {
    case Raw(ErrorType)
}
