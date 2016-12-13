# GarageClientSwift

Swift client library for the [Garage](https://github.com/cookpad/garage) application API

## Requirements

- Swift 3
- Mac OS 10.10+
- iOS 8.0+
- watchOS 2.0+
- tvOS 9.0+

## Installation

### Carthage

1. Add `github "slightair/GarageClientSwift" ~> 2.0` to `Cartfile`
1. Run `carthage update`

## Usage

### 1. Define Garage resource model

```swift
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
```

### 2. Define Garage request

```swift
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
```

### 3. Define Garage configuration

```swift
struct Configuration: GarageConfiguration {
    let endpoint: URL
    let accessToken: String
}

let configuration = Configuration(
    endpoint: URL(string: "http://localhost:3000")!,
    accessToken: "YOUR ACCESS TOKEN"
)
```

### 4. Send request

```swift
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
```

## License

GarageClientSwift is available under the MIT license. See the LICENSE file for more info.
