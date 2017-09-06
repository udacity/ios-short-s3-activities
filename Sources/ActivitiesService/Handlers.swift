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

        guard let pageSize = Int(request.queryParameters["page_size"] ?? "10"), let pageNumber = Int(request.queryParameters["page_number"] ?? "1"),
            pageSize > 0, pageSize <= 50 else {
            Log.error("Cannot initialize query parameters: page_size, page_number. page_size must be (0, 50].")
            try response.send(json: JSON(["message": "Cannot initialize query parameters: page_size, page_number. page_size must be (0, 50]."]))
                        .status(.badRequest).end()
            return
        }

        var activities: [Activity]?
        let id = request.parameters["id"]

        if let id = id {
            activities = try dataAccessor.getActivities(withIDs: [id], pageSize: pageSize, pageNumber: pageNumber)
        } else {
            if let body = request.body, case let .json(json) = body, let idFilter = json["id"].array {
                let ids = idFilter.map({$0.stringValue})
                activities = try dataAccessor.getActivities(withIDs: ids, pageSize: pageSize, pageNumber: pageNumber)
            } else {
                activities = try dataAccessor.getActivities(pageSize: pageSize, pageNumber: pageNumber)
            }
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
            Log.error("Cannot initialize request body. This endpoint expects the request body to be a valid JSON object.")
            try response.send(json: JSON(["message": "Cannot initialize request body. This endpoint expects the request body to be a valid JSON object."]))
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
            ["name", "emoji", "description", "genre", "minParticipants", "maxParticipants"])

        if missingParameters.count != 0 {
            Log.error("Unable to initialize parameters from request body: \(missingParameters).")
            try response.send(json: JSON(["message": "Unable to initialize parameters from request body: \(missingParameters)."]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.createActivity(newActivity)

        if success {
            try response.send(json: JSON(["message": "Activity created."])).status(.created).end()
            return
        }

        try response.status(.notModified).end()
    }

    // MARK: PUT

    public func putActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let body = request.body, case let .json(json) = body else {
            Log.error("Cannot initialize request body. This endpoint expects the request body to be a valid JSON object.")
            try response.send(json: JSON(["message": "Cannot initialize request body. This endpoint expects the request body to be a valid JSON object."]))
                        .status(.badRequest).end()
            return
        }

        guard let id = request.parameters["id"] else {
            Log.error("Cannot initialize path parameter: id.")
            try response.send(json: JSON(["message": "Cannot initialize path parameter: id."]))
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
            ["name", "emoji", "description", "genre", "minParticipants", "maxParticipants"])

        if missingParameters.count != 0 {
            Log.error("Unable to initialize parameters from request body: \(missingParameters).")
            try response.send(json: JSON(["message": "Unable to initialize parameters from request body: \(missingParameters)."]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.updateActivity(updateActivity)

        if success {
            try response.send(json: JSON(["message": "Activity updated."])).status(.OK).end()
            return
        }

        try response.status(.notModified).end()
    }

    // MARK: DELETE

    public func deleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("Cannot initialize path parameter: id.")
            try response.send(json: JSON(["message": "Cannot initialize path parameter: id."]))
                        .status(.badRequest).end()
            return
        }

        let success = try dataAccessor.deleteActivity(withID: id)

        if success {
            try response.send(json: JSON(["message": "Activity deleted."])).status(.noContent).end()
            return
        }

        try response.status(.notModified).end()
    }
}
