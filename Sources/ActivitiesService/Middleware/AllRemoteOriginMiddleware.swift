import Kitura

// MARK: - AllRemoteOriginMiddleware: RouterMiddleware

public class AllRemoteOriginMiddleware: RouterMiddleware {
    public init() {}

    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Swift.Void) {
        response.headers["Access-Control-Allow-Origin"] = "*"
        next()
    }
}
