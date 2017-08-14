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

    public func getExample(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

        guard let id = request.parameters["id"] else {
            Log.error("id (path parameter) missing")
            try response.send(json: JSON(["message": "id (path parameter) missing"]))
                        .status(.badRequest).end()
            return
        }

        let activities = try dataAccessor.getExample(withID: id)

        if activities == nil {
            try response.status(.notFound).end()
            return
        }

        try response.send(json: activities!.toJSON()).status(.OK).end()
    }

    public func getActivities(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
        // Check for id (if exists).
        // Use data accessor to get activities.
        // Return activities.
    }

    // MARK: POST

    public func postActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
        // Check for request body.
        // Validate request body has all activity parameters.
        // Use data accessor to insert activity.
        // Return success/failure.
    }

    // MARK: PUT

    public func putActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
        // Check for id.
        // Check for request body.
        // Validate request body has all activity parameters.
        // Use data accessor to update activity.
        // Return success/failure.
    }

    // MARK: DELETE

    public func deleteActivity(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // TODO: Add implementation.
        // Check for id.
        // Use data accessor to delete activity.
        // Return success/failure.
    }
}
