import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import SwiftKuery

public class Handlers {
    var connectionPool: ConnectionPool

    public init(connectionPool: ConnectionPool) {
       self.connectionPool = connectionPool
    }

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
