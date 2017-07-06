import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI

public class Handlers {
    /**
     * Handler for getting an application/json response.
     */
    public func getActivities(
            request: RouterRequest,
            response: RouterResponse,
            next: @escaping () -> Void) throws {

        Log.debug("GET - /activities route handler...")

    }
}
