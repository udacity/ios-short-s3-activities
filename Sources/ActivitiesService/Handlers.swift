import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import MySQL

// MARK: - Handlers

public class Handlers {
    var connectionPool: MySQLConnectionPool

    public init(connectionPool: MySQLConnectionPool) {
        self.connectionPool = connectionPool
    }

    // MARK: OPTIONS

    public func getOptions(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET,POST,DELETE,OPTIONS,PUT"
        response.status(.OK)
        next()
    }

    // MARK: GET

    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        do {
            // get connection (release to pool when finished)
            let connection = try connectionPool.getConnection()!
            defer { connectionPool.releaseConnection(connection) }

            let result = executeQuery("SELECT * FROM activities", withConnection: connection)
            try returnResult(result, response: response)

        } catch {
            Log.error("cannot get connection from pool")
            try response.status(.internalServerError).end()
        }
    }

    public func getActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        do {
            // get connection (release to pool when finished)
            let connection = try connectionPool.getConnection()!
            defer { connectionPool.releaseConnection(connection) }

            // get id, make request
            if let id = request.parameters["id"] {
                let result = executeQuery("SELECT * FROM activities WHERE id = \(id)", withConnection: connection)
                try returnResult(result, response: response)
            } else {
                try response.status(.badRequest).end()
            }

        } catch {
            Log.error("cannot get connection from pool")
            try response.status(.internalServerError).end()
        }
    }

    // MARK: POST

    public func postActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            try response.status(.badRequest).end()
            return
        }

        guard let name = json["name"].string,
            let description = json["description"].string,
            let genre = json["genre"].string,
            let minParticipants = json["min_participants"].int,
            let maxParticipants = json["max_participants"].int else {
                Log.error("Parameters missing")
                try response.status(.badRequest).end()
                return
        }

        do {
            // get connection (release to pool when finished)
            let connection = try connectionPool.getConnection()!
            defer { connectionPool.releaseConnection(connection) }

            // make request
            let _ = executeQuery("""
                INSERT INTO activities (name, description, genre, min_participants, max_participants)
                VALUES ('\(name)', '\(description)', '\(genre)', \(minParticipants), \(maxParticipants))
                """, withConnection: connection)
            try response.send(json: JSON(["status": 201, "message": "resource created"])).status(.created).end()
        } catch {
            Log.error("cannot get connection from pool")
            try response.status(.internalServerError).end()
        }
    }

    // MARK: Utility

    private func executeQuery(_ query: String, withConnection connection: MySQLConnectionProtocol) -> (MySQLResultProtocol?, error: MySQLError?) {
        let client = MySQLClient(connection: connection)
        return client.execute(query: query)
    }

    private func returnResult(_ result: (MySQLResultProtocol?, error: MySQLError?), response: RouterResponse) throws {

        if let results = result.0 as? MySQLResult {
            let activities = results.toActivities()

            if activities.count > 0 {
                try response.send(json: activities.toJSON()).status(.OK).end()
            } else {
                try response.send(json: JSON([:])).status(.notFound).end()
            }
        } else {
            Log.error(result.1?.localizedDescription ?? "")
            try response.status(.internalServerError).end()
            return
        }
    }
}
