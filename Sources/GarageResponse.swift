import Foundation
import Himotoki

struct GarageResponse<T: Decodable> {
    var resource: T
    var totalCount: Int?
    var linkHeader: LinkHeader?
}
