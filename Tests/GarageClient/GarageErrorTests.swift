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
                            userInfo: [
                                "object": [
                                    "status_code": response.statusCode,
                                    "error": "error message",
                                ],
                                "URLResponse": response,
                            ])

        return .UnacceptableStatusCode(response.statusCode, error)
    }

    func testGarageErrorFromAPIErrorBadRequest() {
        let response = HTTPURLResponse(statusCode: 400)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .BadRequest(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 400)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorUnauthorized() {
        let response = HTTPURLResponse(statusCode: 401)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .Unauthorized(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 401)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorForbidden() {
        let response = HTTPURLResponse(statusCode: 403)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .Forbidden(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 403)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorNotFound() {
        let response = HTTPURLResponse(statusCode: 404)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .NotFound(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 404)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorNotAcceptable() {
        let response = HTTPURLResponse(statusCode: 406)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .NotAcceptable(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 406)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorConflict() {
        let response = HTTPURLResponse(statusCode: 409)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .Conflict(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 409)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorUnsupportedMediaType() {
        let response = HTTPURLResponse(statusCode: 415)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .UnsupportedMediaType(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 415)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorUnprocessableEntity() {
        let response = HTTPURLResponse(statusCode: 422)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .UnprocessableEntity(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 422)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorInternalServerError() {
        let response = HTTPURLResponse(statusCode: 500)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .InternalServerError(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 500)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorServiceUnavailable() {
        let response = HTTPURLResponse(statusCode: 503)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .ServiceUnavailable(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 503)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorClientError() {
        let response = HTTPURLResponse(statusCode: 499)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .ClientError(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 499)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }

    func testGarageErrorFromAPIErrorServerError() {
        let response = HTTPURLResponse(statusCode: 599)
        let APIError = UnacceptableStatusCodeError(response: response)
        let garageError = GarageClient.GarageErrorFromAPIError(APIError)

        switch garageError {
        case .ServerError(let object, let errorResponse):
            XCTAssertEqual(response, errorResponse)
            XCTAssertEqual(object["status_code"], 599)
            XCTAssertEqual(object["error"], "error message")
        default:
            XCTFail("Unexpected error type \(garageError)")
        }
    }
}
