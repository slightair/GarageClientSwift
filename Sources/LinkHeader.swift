import Foundation

public struct LinkHeader {
    public struct Element {
        public let uri: NSURL
        public let rel: String
        public let page: Int

        public init?(string: String) {
            let attributes = string.componentsSeparatedByString("; ")
            guard attributes.count == 3 else {
                return nil
            }

            func trimString(string: String) -> String {
                guard string.characters.count > 2 else {
                    return ""
                }
                return string[string.startIndex.successor()..<string.endIndex.predecessor()]
            }

            func value(field: String) -> String? {
                let pair = field.componentsSeparatedByString("=")
                guard pair.count == 2 else {
                    return nil
                }
                return trimString(pair.last!)
            }

            let uriString = attributes[0]
            guard let uri = NSURL(string: trimString(uriString)) else {
                return nil
            }
            self.uri = uri

            guard let rel = value(attributes[1]) else {
                return nil
            }
            self.rel = rel

            guard let pageString = value(attributes[2]), page = Int(pageString) else {
                return nil
            }
            self.page = page
        }
    }

    public let first: Element?
    public let prev: Element?
    public let next: Element?
    public let last: Element?

    public var hasFirstPage: Bool {
        return first != nil
    }

    public var hasPrevPage: Bool {
        return prev != nil
    }

    public var hasNextPage: Bool {
        return next != nil
    }

    public var hasLastPage: Bool {
        return last != nil
    }

    public init?(string: String) {
        let elements = string.componentsSeparatedByString(", ").flatMap { Element(string: $0) }

        first = elements.filter { $0.rel == "first" }.first
        prev = elements.filter { $0.rel == "prev" }.first
        next = elements.filter { $0.rel == "next" }.first
        last = elements.filter { $0.rel == "last" }.first

        if first == nil && prev == nil && next == nil && last == nil {
            return nil
        }
    }
}
