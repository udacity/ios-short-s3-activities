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

        if request.method != RouterMethod.get {
            try response.status(.badRequest).end()
            return
        }

        if let connection = connectionPool.getConnection() {
           connection.execute("SELECT FROM") {
               (result: QueryResult) in
               Log.debug("Got result")
           }
        }


        Log.debug("GET - /activities route handler...")

        try response.status(.OK).end()
    }
}
