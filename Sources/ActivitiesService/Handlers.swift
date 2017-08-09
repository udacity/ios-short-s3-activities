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

    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        let id = request.parameters["id"]
        try safeDBQuery(response: response) { (accessor: ActivityMySQLDataAccessor) in

            var activities: [Activity]?

            if let id = id {
                activities = try accessor.getActivities(withID: id)
            } else {
                activities = try accessor.getActivities()
            }

            if activities == nil {
                try response.status(.notFound).end()
                return
            }

            try response.send(json: activities!.toJSON()).status(.OK).end()

        }

    }

    // MARK: POST

    public func postActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            try response.status(.badRequest).end()
            return
        }

        let newActivity = Activity(
            id: nil,
            name: json["name"].string,
            emoji: json["emoji"].string,
            description: json["description"].string,
            genre: json["genre"].string,
            minParticipants: json["min_participants"].int,
            maxParticipants: json["max_participants"].int,
            createdAt: nil, updatedAt: nil)

        let missingParameters = newActivity.validate()

        if missingParameters.count != 0 {
            Log.error("parameters missing \(missingParameters)")
            try response.send(json: JSON(["message": "parameters missing \(missingParameters)"]))
                .status(.badRequest).end()
            return
        }

        try safeDBQuery(response: response) { (accessor: ActivityMySQLDataAccessor) in
            let success = try accessor.createActivity(newActivity)

            if success {
                try response.send(json: JSON(["message": "activity created"])).status(.created).end()
                return
            }

            try response.status(.notModified).end()
        }
    }

    // MARK: PUT

    public func putActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

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

        let updateActivity = Activity(
            id: Int(id),
            name: json["name"].string,
            emoji: json["emoji"].string,
            description: json["description"].string,
            genre: json["genre"].string,
            minParticipants: json["min_participants"].int,
            maxParticipants: json["max_participants"].int,
            createdAt: nil,
            updatedAt: nil)

        let missingParameters = updateActivity.validate()

        if missingParameters.count != 0 {
            Log.error("parameters missing \(missingParameters)")
            try response.send(json: JSON(["message": "parameters missing \(missingParameters)"]))
                .status(.badRequest).end()
            return
        }

        try safeDBQuery(response: response) { (accessor: ActivityMySQLDataAccessor) in
            let status = try accessor.updateActivity(updateActivity)

            if status {
                try response.send(json: JSON(["message": "activity updated"])).status(.OK).end()
            }

            try response.status(.notModified).end()
        }

    }

    // MARK: DELETE

    public func deleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.status(.badRequest).end()
            return
        }

        try safeDBQuery(response: response) { (accessor: ActivityMySQLDataAccessor) in
            let status = try accessor.deleteActivity(withID: id)

            if status {
                try response.send(json: JSON(["message": "resource deleted"])).status(.noContent).end()
            }

            try response.status(.notModified).end()
        }
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
            Log.error(error.localizedDescription)
            try response.status(.internalServerError).end()
        }
    }
}
