import MySQL
import Kitura
import LoggerAPI
import Foundation
import SwiftyJSON

// MARK: - Handlers

public class Handlers {

    // MARK: Properties

    var connectionPool: MySQLConnectionPool

    // MARK: Initializer

    public init(connectionPool: MySQLConnectionPool) {
        self.connectionPool = connectionPool
    }

    // MARK: OPTIONS

    public func getOptions(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET,POST,DELETE,OPTIONS,PUT"
        try response.status(.OK).end()
    }

    // MARK: GET

    public func getExample(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.status(.badRequest).end()
            return
        }

        try safeDBQuery(response: response) { (data: MySQLDataAccessor) in
            var activities = try data.getExample(withID: id)
            try self.returnActivities(activities, response: response)
        }
    }

    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
    }

    // MARK: POST

    public func postActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
    }

    // MARK: PUT

    public func putActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
    }

    // MARK: DELETE

    public func deleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
    }

    // MARK: Utility

    // execute queries safely and return error on failure
    private func safeDBQuery(response: RouterResponse, block: @escaping ((_: ActivityMySQLDataAccessor) throws -> Void)) throws {
        do {
            try connectionPool.getConnection() { (connection: MySQLConnectionProtocol) in
                let dataAccessor = ActivityMySQLDataAccessor(connection: connection)
                try block(dataAccessor)
            }
        } catch {
            try returnException(error, response: response)
        }
    }

    private func returnActivities(_ result: [Activity]?, response: RouterResponse) throws {
        guard let activities = result else {
            try response.status(.notFound).end()
            return
        }

        try response.send(json: activities.toJSON()).status(.OK).end()
    }

    private func returnException(_ error: Error, response: RouterResponse) throws {
        Log.error(error.localizedDescription)
        try response.status(.internalServerError).end()
    }
}
