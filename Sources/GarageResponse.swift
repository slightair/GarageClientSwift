import Foundation

struct GarageResponse<T> {
    var resource: T
    var totalCount: Int?
    var linkHeader: LinkHeader?
}
