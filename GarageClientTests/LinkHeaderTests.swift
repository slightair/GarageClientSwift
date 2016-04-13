import XCTest
import APIKit
@testable import GarageClient

class LinkHeaderTests: XCTestCase {
    func testParseLinkHeaderEmpty() {
        let linkHeader = LinkHeader(string: "")
        XCTAssertNil(linkHeader)
    }

    func testParseLinkHeaderInvalid() {
        let linkHeader = LinkHeader(string: ", 1;, , ; page=; ")
        XCTAssertNil(linkHeader)
    }

    func testParseLinkHeaderHasFirst() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users?page=1&per_page=1>; rel=\"first\"; page=\"1\", </v1/users?page=3&per_page=1>; rel=\"prev\"; page=\"3\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        guard let first = linkHeader?.first else {
            XCTFail("should have first element")
            return
        }

        XCTAssertEqual(first.uri, NSURL(string: "/v1/users?page=1&per_page=1")!)
        XCTAssertEqual(first.rel, "first")
        XCTAssertEqual(first.page, 1)
    }

    func testParseLinkHeaderHasPrev() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users?page=1&per_page=1>; rel=\"first\"; page=\"1\", </v1/users?page=3&per_page=1>; rel=\"prev\"; page=\"3\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        guard let prev = linkHeader?.prev else {
            XCTFail("should have prev element")
            return
        }

        XCTAssertEqual(prev.uri, NSURL(string: "/v1/users?page=3&per_page=1")!)
        XCTAssertEqual(prev.rel, "prev")
        XCTAssertEqual(prev.page, 3)
    }

    func testParseLinkHeaderHasNext() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users?page=2&per_page=1>; rel=\"next\"; page=\"2\", </v1/users?page=4&per_page=1>; rel=\"last\"; page=\"4\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        guard let next = linkHeader?.next else {
            XCTFail("should have next element")
            return
        }

        XCTAssertEqual(next.uri, NSURL(string: "/v1/users?page=2&per_page=1")!)
        XCTAssertEqual(next.rel, "next")
        XCTAssertEqual(next.page, 2)
    }

    func testParseLinkHeaderHasLast() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users?page=2&per_page=1>; rel=\"next\"; page=\"2\", </v1/users?page=4&per_page=1>; rel=\"last\"; page=\"4\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        guard let last = linkHeader?.last else {
            XCTFail("should have last element")
            return
        }

        XCTAssertEqual(last.uri, NSURL(string: "/v1/users?page=4&per_page=1")!)
        XCTAssertEqual(last.rel, "last")
        XCTAssertEqual(last.page, 4)
    }

    func testParseLinkHeaderAll() {
        // swiftlint:disable:next line_length
        let linkHeaderString = "</v1/users?page=1&per_page=1>; rel=\"first\"; page=\"1\", </v1/users?page=2&per_page=1>; rel=\"prev\"; page=\"2\", </v1/users?page=4&per_page=1>; rel=\"next\"; page=\"4\", </v1/users?page=4&per_page=1>; rel=\"last\"; page=\"4\""
        let linkHeader = LinkHeader(string: linkHeaderString)

        let first = linkHeader?.first
        XCTAssertNotNil(first)
        XCTAssertEqual(first?.uri, NSURL(string: "/v1/users?page=1&per_page=1")!)
        XCTAssertEqual(first?.rel, "first")
        XCTAssertEqual(first?.page, 1)

        let prev = linkHeader?.prev
        XCTAssertNotNil(prev)
        XCTAssertEqual(prev?.uri, NSURL(string: "/v1/users?page=2&per_page=1")!)
        XCTAssertEqual(prev?.rel, "prev")
        XCTAssertEqual(prev?.page, 2)

        let next = linkHeader?.next
        XCTAssertNotNil(next)
        XCTAssertEqual(next?.uri, NSURL(string: "/v1/users?page=4&per_page=1")!)
        XCTAssertEqual(next?.rel, "next")
        XCTAssertEqual(next?.page, 4)

        let last = linkHeader?.last
        XCTAssertNotNil(last)
        XCTAssertEqual(last?.uri, NSURL(string: "/v1/users?page=4&per_page=1")!)
        XCTAssertEqual(last?.rel, "last")
        XCTAssertEqual(last?.page, 4)
    }
}
