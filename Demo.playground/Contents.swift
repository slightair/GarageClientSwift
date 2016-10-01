import PlaygroundSupport
import UIKit
import APIKit
import Himotoki
import GarageClient

PlaygroundPage.current.needsIndefiniteExecution = true

//: Step 1: Define Garage resource decodable model
struct User: Decodable {
    let id: Int
    let name: String
    let email: String

    static func decode(_ e: Extractor) throws -> User {
        return try User(
            id: e <| "id",
            name: e <| "name",
            email: e <| "email"
        )
    }
}

//: Step 2: Define Garage request settings
struct GetUsersRequest: GarageRequest {
    typealias Resource = [User]

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/users"
    }

    var queryParameters: [String: Any]? {
        return [
            "per_page": 1,
            "page": 2,
        ]
    }
}

//: Step 3: Define Garage configuration
struct Configuration: GarageConfiguration {
    let endpoint: URL
    let accessToken: String
}

let configuration = Configuration(
    endpoint: URL(string: "http://localhost:3000")!,
    accessToken: ""
)

//: Step 4: Send request
let garageClient = GarageClient(configuration: configuration)
garageClient.sendRequest(GetUsersRequest()) { result in
    switch result {
    case .success(let response):
        debugPrint(response)

        let users = response.resource
        debugPrint(users)
    case .failure(let error):
        debugPrint(error)
    }
}
