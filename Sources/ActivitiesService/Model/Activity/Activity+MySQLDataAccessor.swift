import MySQL

// MARK: - ActivityMySQLDataAccessor

class ActivityMySQLDataAccessor {

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

    func createActivity(_ activity: Activity) throws -> Bool {
        let insertQuery = MySQLQueryBuilder()
                .insert(data: activity.toMySQLRow(), table: "activities")

        let result = try connection.execute(builder: insertQuery)

        return result.affectedRows > 0
    }

    func updateActivity(_ activity: Activity) throws -> Bool {
        let updateQuery = MySQLQueryBuilder()
                .update(data: activity.toMySQLRow(), table: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(activity.id!)")

        let result = try connection.execute(builder: updateQuery)

        return result.affectedRows > 0
    }

    func deleteActivity(withID id: String) throws -> Bool {
        let deleteQuery = MySQLQueryBuilder()
                .delete(fromTable: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(id)")

        let result = try connection.execute(builder: deleteQuery)

        return result.affectedRows > 0
    }

    func getActivities(withID id: String) throws -> [Activity]? {
        let select = selectActivities.wheres(statement:"WHERE Id=?", parameters: id)

        let result = try connection.execute(builder: select)
        let activities = result.toActivities()

        return (activities.count == 0) ? nil : activities
    }

    func getActivities() throws -> [Activity]? {
        let result = try connection.execute(builder: selectActivities)
        let activities = result.toActivities()

        return (activities.count == 0) ? nil : activities
    }
}
