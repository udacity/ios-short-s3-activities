import MySQL
import LoggerAPI

// MARK: - ActivityMySQLDataAccessorProtocol

public protocol ActivityMySQLDataAccessorProtocol {
    func createActivity(_ activity: Activity) throws -> Bool
    func updateActivity(_ activity: Activity) throws -> Bool
    func deleteActivity(withID id: String) throws -> Bool
    func getActivities(withIDs ids: [String], pageSize: Int, pageNumber: Int) throws -> [Activity]?
    func getActivities(pageSize: Int, pageNumber: Int) throws -> [Activity]?
}

// MARK: - ActivityMySQLDataAccessor: ActivityMySQLDataAccessorProtocol

public class ActivityMySQLDataAccessor: ActivityMySQLDataAccessorProtocol {

    // MARK: Properties

    let pool: MySQLConnectionPoolProtocol

    // MARK: Initializer

    public init(pool: MySQLConnectionPoolProtocol) {
        self.pool = pool
    }

    // MARK: Queries

    public func createActivity(_ activity: Activity) throws -> Bool {
        let insertQuery = MySQLQueryBuilder()
                .insert(data: activity.toMySQLRow(), table: "activities")

        let result = try execute(builder: insertQuery)
        return result.affectedRows > 0
    }

    public func updateActivity(_ activity: Activity) throws -> Bool {
        let updateQuery = MySQLQueryBuilder()
                .update(data: activity.toMySQLRow(), table: "activities")
                .wheres(statement: "Id=?", parameters: "\(activity.id!)")

        let result = try execute(builder: updateQuery)
        return result.affectedRows > 0
    }

    public func deleteActivity(withID id: String) throws -> Bool {
        let deleteQuery = MySQLQueryBuilder()
                .delete(fromTable: "activities")
                .wheres(statement: "Id=?", parameters: "\(id)")
        
        let result = try execute(builder: deleteQuery)
        return result.affectedRows > 0
    }

    public func getActivities(withIDs ids: [String], pageSize: Int = 10, pageNumber: Int = 1) throws -> [Activity]? {
        let selectQuery = MySQLQueryBuilder()
            .select(fields: ["id", "name", "emoji", "description", "genre",
            "min_participants", "max_participants", "created_at", "updated_at"], table: "activities")
            .wheres(statement: "id IN (?)", parameters: ids)

        let result = try execute(builder: selectQuery)
        result.seek(offset: cacluateOffset(pageSize: pageSize, pageNumber: pageNumber))

        let activities = result.toActivities(pageSize: pageSize)
        return (activities.count == 0) ? nil : activities
    }

    public func getActivities(pageSize: Int = 10, pageNumber: Int = 1) throws -> [Activity]? {
        let selectQuery = MySQLQueryBuilder()
            .select(fields: ["id", "name", "emoji", "description", "genre",
            "min_participants", "max_participants", "created_at", "updated_at"], table: "activities")

        let result = try execute(builder: selectQuery)
        result.seek(offset: cacluateOffset(pageSize: pageSize, pageNumber: pageNumber))

        let activities = result.toActivities(pageSize: pageSize)
        return (activities.count == 0) ? nil : activities
    }

    // MARK: Utility

    func execute(builder: MySQLQueryBuilder) throws -> MySQLResultProtocol {
        let connection = try pool.getConnection()
        defer { pool.releaseConnection(connection!) }

        return try connection!.execute(builder: builder)
    }

    func cacluateOffset(pageSize: Int, pageNumber: Int) -> Int64 {
        return Int64(pageNumber > 1 ? pageSize * (pageNumber - 1) : 0)
    }

    public func isConnected() -> Bool {
        do {
            let connection = try pool.getConnection()
            defer { pool.releaseConnection(connection!) }
        } catch {
            return false
        }
        return true
    }
}
