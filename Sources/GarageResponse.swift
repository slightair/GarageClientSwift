import Foundation

struct GarageResponse<T> {
    var result: T
    var totalCount: Int?
    var linkHeader: LinkHeader?
}
