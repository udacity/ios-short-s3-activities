import MySQL
import LoggerAPI

// MARK: - ActivityMySQLDataAccessor

class ActivityMySQLDataAccessor {

    // MARK: Properties

    let connection: MySQLConnectionProtocol

    // MARK: Initializer

    init(connection: MySQLConnectionProtocol) {
        self.connection = connection
    }

    // MARK: Queries

    func createActivity(_ activity: Activity) throws {
        // TODO: Add implementation.
        // Execute insert query.
    }

    func updateActivity(_ activity: Activity, withID id: String) throws {
        // TODO: Add implementation.
        // Execute update query (for specific id).
    }

    func deleteActivity(withID id: String) throws {
        // TODO: Add implementation.
        // Execute delete query (for specific id).
    }

    func getExample(withID id: String) throws -> [Activity]? {
        let result = try connection.execute(query: "SELECT name FROM activities WHERE id=\(id)")
        let activities = result.toActivities()
        
        return (activities.count == 0) ? nil : activities
    }

    func getActivities(withID id: String) throws -> [Activity]? {
        // TODO: Add implementation.
        // Execute select query (for specific id).
        return nil
    }

    func getActivities() throws -> [Activity]? {
        // TODO: Add implementation.
        // Execute select query (get all activities).
        return nil
    }
}
