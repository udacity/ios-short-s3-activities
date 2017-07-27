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

        Log.info("GET - /activities route handler...")

        if request.method != RouterMethod.get {
            try response.status(.badRequest).end()
            return
        }

        getActivities { (result: QueryResult) in
            do {
                try self.returnResult(result, response: response)
            } catch {
                Log.error("Error info: \(error)")
            }
        }
    }

    private func getActivities(completion: @escaping (QueryResult) -> ()) {
        if let connection = connectionPool.getConnection() {
            connection.execute("SELECT * FROM activities") { (result: QueryResult) in
                completion(result)
            }
        } else {
            Log.error("cannot get connection from pool")
        }
    }

    private func returnResult(_ result: QueryResult, response: RouterResponse) throws {
        if let _ = result.asError {
            try response.status(.internalServerError).end()
            return
        }

        let activities = result.toActivities()

        if activities.count > 0 {
            try response.send(json: activities.toJSON()).status(.OK).end()
        } else {
            try response.status(.notFound).end()
        }
    }
}
