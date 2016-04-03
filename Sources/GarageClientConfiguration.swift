import Foundation

protocol GarageClientConfiguration {
    var endpoint: NSURL { get }
    var headers: [String: String] { get }
    var pathPrefix: String { get }
    var verbose: Bool { get }
}

extension GarageClientConfiguration {
    var defaultUserAgent: String {
        let clientName = "GarageClientSwift"

        if let info = NSBundle.mainBundle().infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            return "\(clientName) \(executable) (\(version))"
        }

        return clientName
    }

    var headers: [String: String] {
        return [
            "Accept": "application/json",
            "User-Agent": defaultUserAgent,
        ]
    }

    var pathPrefix: String {
        return "v1"
    }

    var verbose: Bool {
        return false
    }
}
