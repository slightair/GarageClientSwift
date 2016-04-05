import UIKit
import APIKit
import Himotoki

struct Configuration: GarageConfigurationType {
    let endpoint: NSURL
    let accessToken: NSString
}

struct GetUserRequest: GarageRequestType {
    typealias Response = User

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/users/1"
    }

    func responseFromObject(object: AnyObject, urlResponse: NSHTTPURLResponse) -> Response? {
        return nil
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = Configuration(
            endpoint: NSURL(string: "http://localhost:3000")!,
            accessToken: ""
        )

        let client = Client(configuration: configuration)
        let request = GetUserRequest()

        client.sendRequest(request) { result in
            switch result {
            case .Success(let user):
                print(user.name)
            case .Failure(let error):
                print(error)
            }
        }
    }
}
