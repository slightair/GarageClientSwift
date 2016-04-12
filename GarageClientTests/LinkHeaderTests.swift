import XCTest
import APIKit
@testable import GarageClient

class LinkHeaderTests: XCTestCase {
    func testParseLinkHeaderEmpty() {
        let linkHeader = LinkHeader(string: "")
        XCTAssertNil(linkHeader)
    }

    func testParseLinkHeaderHasLast() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users/1?page=2&per_page=1>; rel=\"next\"; page=\"2\", </v1/users/1?page=4&per_page=1>; rel=\"last\"; page=\"4\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        guard let last = linkHeader?.last else {
            XCTFail("should have last element")
            return
        }

        XCTAssertEqual(last.uri, NSURL(string: "/v1/users/1?page=4&per_page=1")!)
        XCTAssertEqual(last.rel, "last")
        XCTAssertEqual(last.page, 4)
    }
}
