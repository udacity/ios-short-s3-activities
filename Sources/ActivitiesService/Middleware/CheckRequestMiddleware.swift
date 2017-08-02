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
            if request.method != method {
                try response.status(.badRequest).end()
            } else {
                next()
            }
        } catch {
            Log.error("Failed to send response")
        }
    }
}
