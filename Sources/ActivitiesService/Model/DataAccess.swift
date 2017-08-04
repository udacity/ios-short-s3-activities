import MySQL

class DataAccess {
    let connection: MySQLConnectionProtocol

    let selectActivities = MySQLQueryBuilder()
            .select(fields: ["id", "name", "emoji", "description", "genre",
            "min_participants", "max_participants", "created_at", "updated_at"], table: "activities")


    init(connection: MySQLConnectionProtocol) {
        self.connection = connection
    }

    func updateActivity(id: String, data: MySQLRow) throws {
        let updateQuery = MySQLQueryBuilder()
                .update(data: data, table: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(id)")

        let _ = try connection.execute(builder: updateQuery)
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
