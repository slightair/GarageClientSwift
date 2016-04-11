import Foundation

struct LinkHeader {
    struct Element {
        let uri: NSURL
        let rel: String
        let page: Int
    }

    let first: Element?
    let prev: Element?
    let next: Element?
    let last: Element?

    var hasFirstPage: Bool {
        return first != nil
    }

    var hasPrevPage: Bool {
        return prev != nil
    }

    var hasNextPage: Bool {
        return next != nil
    }

    var hasLastPage: Bool {
        return last != nil
    }
}
