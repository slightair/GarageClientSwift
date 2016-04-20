import Foundation

public struct GarageResponse<T> {
    public var resource: T
    public var totalCount: Int?
    public var linkHeader: LinkHeader?
}
