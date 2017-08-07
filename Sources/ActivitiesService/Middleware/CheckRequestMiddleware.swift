import Kitura
import LoggerAPI

// MARK: - CheckRequestMiddleware: RouterMiddleware

public class CheckRequestMiddleware: RouterMiddleware {

    let method: RouterMethod

    public init(method: RouterMethod) {
        self.method = method
    }

    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Swift.Void) {
        do {
            if request.method == method {
                next()
            } else {
                Log.error("Request method \(request.method) doesn't match expectation")
                try response.status(.badRequest).end()
            }
        } catch {
            Log.error("Failed to send response")
        }
    }
}
