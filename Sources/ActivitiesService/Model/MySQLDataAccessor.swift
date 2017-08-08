import MySQL

// MARK: - MySQLDataAccessor

class MySQLDataAccessor {

    // MARK: Properties

    let connection: MySQLConnectionProtocol

    // MARK: Initializer

    init(connection: MySQLConnectionProtocol) {
        self.connection = connection
    }

    // MARK: Queries

    func createActivity(_ activity: Activity) throws {
        // TODO: Add implementation.
    }

    func updateActivity(_ activity: Activity, withID id: String) throws {
        // TODO: Add implementation.
    }

    func deleteActivity(withID id: String) throws {
        // TODO: Add implementation.
    }

    func getExample(withID id: String) throws -> [Activity]? {
        guard let result = try connection.execute(query: "SELECT * FROM activities WHERE id=\(id)") else {
            return nil
        }

        return result.toActivities()
    }

    func getActivities(withID id: String) throws -> [Activity]? {
        // TODO: Add implementation.
        return nil
    }

    func getActivities() throws -> [Activity]? {
        // TODO: Add implementation.
        return nil
    }
}
