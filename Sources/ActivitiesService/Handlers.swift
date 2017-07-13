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
    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        if request.method != RouterMethod.get {
            try response.status(.badRequest).end()
            return
        }

        if let connection = connectionPool.getConnection() {
           connection.execute("SELECT * FROM activities") { (result: QueryResult) in
               self.returnResult(result, response: response)
           }
        }

        Log.debug("GET - /activities route handler...")
    }

    private func returnResult(_ result: QueryResult, response: RouterResponse) {
        do {
            if let error = result.asError {
                try response.status(.internalServerError).end()
                return
            }

            let activities = result.toActivities()
            try response.send(json: activities.toJSON()).status(.OK).end()
        } catch {}
    }
}
