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
           connection.execute("SELECT * FROM activities") {
               (result: QueryResult) in
               print("Got result")

               self.returnResult(result, response: response)
           }
        }

        try response.send(json: JSON(["ok":"ok"])).status(.OK).end()
        Log.debug("GET - /activities route handler...")
    }

    private func returnResult(_ result: QueryResult, response: RouterResponse) {
        do {
            var json = JSON(["ok": "ok"])
            try response.send(json: json).status(.OK).end()
        } catch {}
    }
}
