import UIKit

struct Configuration: ClientConfigurationType {
    let endpoint: NSURL
    let accessToken: NSString
}

struct GetUserRequest: ClientRequestType {
    typealias Response = User
}

//{
//    "id":1,
//    "name":"alice",
//    "email":"alice@example.com",
//    "_links":{"posts":{"href":"/v1/users/1/posts"}}
//}
struct User {
    let name: String
    let email: String
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
