import MySQL
import Kitura
import LoggerAPI
import Foundation
import SwiftyJSON

// MARK: - Handlers

public class Handlers {

    // MARK: Properties

    let dataAccessor: ActivityMySQLDataAccessorProtocol

    // MARK: Initializer

    public init(dataAccessor: ActivityMySQLDataAccessorProtocol) {
        self.dataAccessor = dataAccessor
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

        guard let pageSize = UInt(request.queryParameters["pageSize"] ?? "0"), let offset = UInt64(request.queryParameters["offset"] ?? "0") else {
            Log.error("could not initialize pageSize and offset")
            try response.send(json: JSON(["message": "could not initialize pageSize and offset"]))
                        .status(.internalServerError).end()
            return
        }

        var activities: [Activity]?

        if let id = id {
            activities = try dataAccessor.getActivities(withID: id)
        } else {
            activities = try dataAccessor.getActivities(pageSize: pageSize, offset: offset)
        }

        if activities == nil {
            try response.status(.notFound).end()
            return
        }

        try response.send(json: activities!.toJSON()).status(.OK).end()
    }

    // MARK: POST

    public func postActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("body contains invalid JSON")
            try response.send(json: JSON(["message": "body is missing JSON or JSON is invalid"]))
                        .status(.badRequest).end()
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

        let missingParameters = newActivity.validateParameters(
            ["name", "emoji", "description", "genre", "min_participants", "max_participants"])

        if missingParameters.count != 0 {
            Log.error("parameters missing \(missingParameters)")
            try response.send(json: JSON(["message": "parameters missing \(missingParameters)"]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.createActivity(newActivity)

        if success {
            try response.send(json: JSON(["message": "activity created"])).status(.created).end()
            return
        }

        try response.status(.notModified).end()
    }

    // MARK: PUT

    public func putActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("body contains invalid JSON")
            try response.send(json: JSON(["message": "body is missing JSON or JSON is invalid"]))
                        .status(.badRequest).end()
            return
        }

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.send(json: JSON(["message": "id (path parameter) missing"]))
                        .status(.badRequest).end()
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

        let missingParameters = updateActivity.validateParameters(
            ["name", "emoji", "description", "genre", "min_participants", "max_participants"])

        if missingParameters.count != 0 {
            Log.error("parameters missing \(missingParameters)")
            try response.send(json: JSON(["message": "parameters missing \(missingParameters)"]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.updateActivity(updateActivity)

        if success {
            try response.send(json: JSON(["message": "activity updated"])).status(.OK).end()
        }

        try response.status(.notModified).end()
    }

    // MARK: DELETE

    public func deleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.send(json: JSON(["message": "id (path parameter) missing"]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.deleteActivity(withID: id)

        if success {
            try response.send(json: JSON(["message": "resource deleted"])).status(.noContent).end()
        }

        try response.status(.notModified).end()
    }
}
