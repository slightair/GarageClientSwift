import UIKit
import APIKit
import Himotoki

struct Configuration: GarageConfigurationType {
    let endpoint: NSURL
    let accessToken: String
}

struct GetUserRequest: GarageRequestType {
    typealias Resource = User

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/users/1"
    }
}

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

class ViewController: UIViewController {
    let garageClient: GarageClient

    required init?(coder aDecoder: NSCoder) {
        let configuration = Configuration(
            endpoint: NSURL(string: "http://localhost:3000")!,
            accessToken: ""
        )
        garageClient = GarageClient(configuration: configuration)

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        garageClient.sendRequest(GetUserRequest()) { result in
            switch result {
            case .Success(let response):
                print(response)

                let user = response.resource
                print(user)
            case .Failure(let error):
                print(error)
            }
        }
    }
}
