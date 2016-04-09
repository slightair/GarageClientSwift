import XCTest
import APIKit
@testable import GarageClient

class GarageErrorTests: XCTestCase {

    func HTTPURLResponse(statusCode statusCode: Int) -> NSHTTPURLResponse {
        let url = NSURL(string: "https://example.com")!
        return NSHTTPURLResponse(URL: url,
                                 statusCode: statusCode,
                                 HTTPVersion: "HTTP/1.1",
                                 headerFields: nil)!
    }

    func UnacceptableStatusCodeError(response response: NSHTTPURLResponse) -> APIError {
        let error = NSError(domain: "APIKitErrorDomain",
                            code: 0,
                            userInfo: ["URLResponse": response])

        return .UnacceptableStatusCode(response.statusCode, error)
    }

    func testGarageErrorFromAPIErrorBadRequest() {
        let response = HTTPURLResponse(statusCode: 400)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        XCTAssert(garageError == GarageError.BadRequest(response))
    }
}
