import XCPlayground
import UIKit
import APIKit
import Himotoki
import GarageClient

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: Step 1: Define Garage resource decodable model
struct User: Decodable {
    let id: Int
    let name: String
    let email: String

    static func decode(e: Extractor) throws -> User {
        return User(
            id: try e <| "id",
            name: try e <| "name",
            email: try e <| "email"
        )
    }
}

//: Step 2: Define Garage request settings
struct GetUserRequest: GarageRequestType {
    typealias Resource = [User]

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/users"
    }

    var parameters: AnyObject? {
        return [
            "per_page": 1,
            "page": 2,
        ]
    }
}

//: Step 3: Define Garage configuration
struct Configuration: GarageConfigurationType {
    let endpoint: NSURL
    let accessToken: String
}

let configuration = Configuration(
    endpoint: NSURL(string: "http://localhost:3000")!,
    accessToken: ""
)

//: Step 4: Send request
let garageClient = GarageClient(configuration: configuration)
garageClient.sendRequest(GetUserRequest()) { result in
    switch result {
    case .Success(let response):
        debugPrint(response)

        let user = response.resource
        debugPrint(user)
    case .Failure(let error):
        debugPrint(error)
    }
}
