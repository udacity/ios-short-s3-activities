import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import MySQL

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

    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        let id = request.parameters["id"]
        try safeDBQuery(response: response) {
            (data: DataAccess) in

            var activities: [Activity]?

            if let id = id {
                activities = try data.getActivities(withID: id)
            } else {
                activities = try data.getActivities()
            }
            
            try self.returnActivities(activities, response: response)
        }
    }

     /*
    // MARK: POST

    public func onCreateActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            try response.status(.badRequest).end()
            return
        }

        let newActivity = Activity(id: nil, name: json["name"].string,
            emoji: json["emoji"].string, description: json["description"].string,
            genre: json["genre"].string, minParticipants: json["min_participants"].int,
            maxParticipants: json["max_participants"].int, createdAt: nil, updatedAt: nil)
        let data = newActivity.toDataMySQLRow()
        let missingParameters = data.1

        guard missingParameters.count == 0 else {
            Log.error("parameters missing \(data.1)")
            try response.send(json: JSON(["status": 400, "message": "parameters missing \(data.1)"])).status(.badRequest).end()
            return
        }

        do {
            if let connection = try connectionPool.getConnection() {
                defer { connectionPool.releaseConnection(connection) }
                try createNewActivity(data.0, connection: connection, response: response)
            } else {
                try response.status(.internalServerError).end()
            }
        }
    }

    private func createNewActivity(_ data: MySQLRow, connection: MySQLConnectionProtocol, response: RouterResponse) throws {
        do {
            let insertQuery = MySQLQueryBuilder()
                .insert(data: data, table: "activities")

            let _ = executeQuery(insertQuery, connection: connection)
            try response.send(json: JSON(["status": 201, "message": "resource created"])).status(.created).end()
        }
    }

    // MARK: PUT

    public func onUpdateActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            try response.status(.badRequest).end()
            return
        }

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.status(.badRequest).end()
            return
        }

        let tempActivity = Activity(id: Int(id), name: json["name"].string,
            emoji: json["emoji"].string, description: json["description"].string,
            genre: json["genre"].string, minParticipants: json["min_participants"].int,
            maxParticipants: json["max_participants"].int, createdAt: nil, updatedAt: nil)
        let data = tempActivity.toDataMySQLRow()

        do {
            if let connection = try connectionPool.getConnection() {
                defer { connectionPool.releaseConnection(connection) }
                try updateActivityWithID(id, data: data.0, connection: connection, response: response)
            } else {
                try response.status(.internalServerError).end()
            }
        }
    }

    private func updateActivityWithID(_ id: String, data: MySQLRow, connection: MySQLConnectionProtocol, response: RouterResponse) throws {
    }

    // MARK: DELETE

    public func onDeleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.status(.badRequest).end()
            return
        }

        do {
            if let connection = try connectionPool.getConnection() {
                defer { connectionPool.releaseConnection(connection) }
                try deleteActivityWithID(id, connection: connection, response: response)
            } else {
                try response.status(.internalServerError).end()
            }
        }
    }

    private func deleteActivityWithID(_ id: String, connection: MySQLConnectionProtocol, response: RouterResponse) throws {
        do {
            let deleteQuery = MySQLQueryBuilder()
                .delete(fromTable: "activities").wheres(statement: "WHERE Id=?", parameters: "\(id)")

            let _ = executeQuery(deleteQuery, connection: connection)
            try response.send(json: JSON(["status": 204, "message": "resource deleted"])).status(.noContent).end()
        }
    }
*/


    // execute queries safely
    private func safeDBQuery(response: RouterResponse, block: @escaping ((_: DataAccess) throws -> Void)) throws {
        do {
            try connectionPool.getConnection() {
                (connection: MySQLConnectionProtocol) in
                let dataAccess = DataAccess(connection: connection)
                
                try block(dataAccess)
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
        Log.error(error.localizedDescription ?? "")
        try response.status(.internalServerError).end()
    }
}
