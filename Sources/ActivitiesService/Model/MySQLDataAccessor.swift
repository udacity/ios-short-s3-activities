import MySQL

// MARK: - MySQLDataAccessor

class MySQLDataAccessor {

    // MARK: Properties

    let connection: MySQLConnectionProtocol

    let selectActivities = MySQLQueryBuilder()
            .select(fields: ["id", "name", "emoji", "description", "genre",
            "min_participants", "max_participants", "created_at", "updated_at"], table: "activities")

    // MARK: Initializer

    init(connection: MySQLConnectionProtocol) {
        self.connection = connection
    }

    // MARK: Queries

    func createActivity(_ activity: Activity) throws {
        let insertQuery = MySQLQueryBuilder()
                .insert(data: activity.toMySQLRow(), table: "activities")

        let _ = try connection.execute(builder: insertQuery)
    }

    func updateActivity(_ activity: Activity, withID id: String) throws {
        let updateQuery = MySQLQueryBuilder()
                .update(data: activity.toMySQLRow(), table: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(id)")

        let _ = try connection.execute(builder: updateQuery)
    }

    func deleteActivity(withID id: String) throws {
        let deleteQuery = MySQLQueryBuilder()
                .delete(fromTable: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(id)")

        let _ = try connection.execute(builder: deleteQuery)
    }

    func getActivities(withID id: String) throws -> [Activity]? {
        let select = selectActivities.wheres(statement:"WHERE Id=?", parameters: id)

        guard let result = try connection.execute(builder: select) else {
            return nil
        }

        return result.toActivities()
    }

    func getActivities() throws -> [Activity]? {
        guard let result = try connection.execute(builder: selectActivities) else {
            return nil
        }

        return result.toActivities()
    }
}
