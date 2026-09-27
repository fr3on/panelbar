import Foundation
import PanelBarCore

public final class MockHTTPTransport: HTTPTransport, @unchecked Sendable {
    public typealias Handler = @Sendable (URLRequest) throws -> (Data, HTTPURLResponse)
    private var handler: Handler

    public init(handler: @escaping Handler) {
        self.handler = handler
    }

    public func execute(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try handler(request)
    }

    public static func response(_ statusCode: Int, _ data: Data, url: URL = URL(string: "https://host.example.com:2083")!) -> (Data, HTTPURLResponse) {
        (data, HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"])!)
    }
}

/// A thread-safe recorder for what a mock transport saw, since its handler closure is `@Sendable`.
public final class CallRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private var storedPaths: [String] = []
    private var storedAuth: [String] = []
    private var storedURLs: [URL] = []
    private var storedCount = 0

    public init() {}

    public func record(path: String? = nil, auth: String? = nil, url: URL? = nil) {
        lock.withLock {
            storedCount += 1
            if let path { storedPaths.append(path) }
            if let auth { storedAuth.append(auth) }
            if let url { storedURLs.append(url) }
        }
    }

    public var paths: [String] { lock.withLock { storedPaths } }
    public var auth: [String] { lock.withLock { storedAuth } }
    public var urls: [URL] { lock.withLock { storedURLs } }
    public var count: Int { lock.withLock { storedCount } }
}
