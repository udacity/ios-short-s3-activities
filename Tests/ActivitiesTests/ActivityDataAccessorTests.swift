import XCTest

@testable import ActivitiesService
@testable import MySQL

class ActivityMySQLDataAccessorTests: XCTestCase {
    var connection: MockMySQLConnection?
    var connectionPool: MockMySQLConnectionPool?
    var dao: ActivityMySQLDataAccessor?

    public override func setUp() {
        connection = MockMySQLConnection()

        let connectionString = MySQLConnectionString(host: "127.0.0.1")
        connectionPool = MockMySQLConnectionPool(connectionString: connectionString,
                                                  poolSize: 1,
                                                  defaultCharset: "utf8")
        connectionPool!.getConnectionReturn = connection

        dao = ActivityMySQLDataAccessor(pool: connectionPool!)
    }

    func testCreateActivityCallsExecute() throws {
        _ = try dao!.createActivity(Activity())

        XCTAssertTrue(connection!.executeBuilderCalled)
    }

    func testCreateActivityReturnsTrueOnSuccess() throws {
        let result = MockMySQLResult()
        result.affectedRows = 1
        connection!.executeMySQLResultReturn = result

        let created = try dao!.createActivity(Activity())

        XCTAssertTrue(created)
    }

    func testCreateActivityReturnsFalseOnFail() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        let created = try dao!.createActivity(Activity())

        XCTAssertFalse(created)
    }

    func testUpdateActivityCallsExecute() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        var activity = Activity()
        activity.id = 1234
        _ = try dao!.updateActivity(activity)

        let query = connection!.executeBuilderParams?.build()
        let containsWhere = query!.contains("WHERE Id='1234'")
        XCTAssertTrue(containsWhere, "query should have been executed with correct parameters: \(query!)")
    }

    func testUpdateActivityReturnsTrueOnSuccess() throws {
        let result = MockMySQLResult()
        result.affectedRows = 1
        connection!.executeMySQLResultReturn = result

        var activity = Activity()
        activity.id = 1234
        let created = try dao!.updateActivity(activity)

        XCTAssertTrue(created)
    }

    func testUpdateActivityReturnsFalseOnFail() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        var activity = Activity()
        activity.id = 1234
        let created = try dao!.updateActivity(activity)

        XCTAssertFalse(created)
    }

    func testDeleteActivityCallsExecute() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        _ = try dao!.deleteActivity(withID: "1234")

        let query = connection!.executeBuilderParams?.build()
        let containsWhere = query!.contains("WHERE Id='1234'")
        XCTAssertTrue(containsWhere, "query should have been executed with correct parameters: \(query!)")
    }

    func testDeleteActivityReturnsTrueOnSuccess() throws {
        let result = MockMySQLResult()
        result.affectedRows = 1
        connection!.executeMySQLResultReturn = result

        let created = try dao!.deleteActivity(withID: "1234")

        XCTAssertTrue(created)
    }

    func testDeleteActivityReturnsFalseOnFail() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        let created = try dao!.deleteActivity(withID: "1234")

        XCTAssertFalse(created)
    }

    func testGetActivityWithIDCallsExecute() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        _ = try dao!.getActivities(withID: "1234")

        let query = connection!.executeBuilderParams?.build()
        let containsWhere = query!.contains("WHERE Id='1234'")
        XCTAssertTrue(containsWhere, "query should have been executed with correct parameters: \(query!)")
    }

    func testGetActivityWithIDReturnsActivitiesOnSuccess() throws {
        let result = MockMySQLResult()
        result.affectedRows = -1
        result.results = [["id": 1234]]
        connection!.executeMySQLResultReturn = result

        let activities = try dao!.getActivities(withID: "1234")

        XCTAssertEqual(1234, activities![0].id)
    }

    func testGetActivityWithIDReturnsNilOnFail() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        let activities = try dao!.getActivities(withID: "1234")

        XCTAssertNil(activities)
    }

    func testGetActivitiesCallsExecute() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        _ = try dao!.getActivities()

        let query = connection!.executeBuilderParams?.build()
        let containsWhere = query!.contains("WHERE")
        XCTAssertFalse(containsWhere, "query should have not have been executed with a where clause, query: \(query!)")
    }

    func testGetActivitiesReturnsActivitiesOnSuccess() throws {
        let result = MockMySQLResult()
        result.affectedRows = -1
        result.results = [["id": 1234]]
        connection!.executeMySQLResultReturn = result

        let activities = try dao!.getActivities()

        XCTAssertEqual(1234, activities![0].id)
    }

    func testGetActivitiesReturnsNilOnFail() throws {
        let result = MockMySQLResult()
        result.affectedRows = 0
        connection!.executeMySQLResultReturn = result

        let activities = try dao!.getActivities()

        XCTAssertNil(activities)
    }

}

#if os(Linux)
extension ActivityMySQLDataAccessorTests {
    static var allTests: [(String, (ActivityMySQLDataAccessorTests) -> () throws -> Void)] {
        return [
            ("testCreateActivityCallsExecute", testCreateActivityCallsExecute),
            ("testCreateActivityReturnsTrueOnSuccess", testCreateActivityReturnsTrueOnSuccess),
            ("testCreateActivityReturnsFalseOnFail", testCreateActivityReturnsFalseOnFail),
            ("testUpdateActivityCallsExecute", testUpdateActivityCallsExecute),
            ("testUpdateActivityReturnsTrueOnSuccess", testUpdateActivityReturnsTrueOnSuccess),
            ("testUpdateActivityReturnsFalseOnFail", testUpdateActivityReturnsFalseOnFail),
            ("testDeleteActivityCallsExecute", testDeleteActivityCallsExecute),
            ("testDeleteActivityReturnsTrueOnSuccess", testDeleteActivityReturnsTrueOnSuccess),
            ("testDeleteActivityReturnsFalseOnFail", testDeleteActivityReturnsFalseOnFail),
            ("testGetActivityWithIDCallsExecute", testGetActivityWithIDCallsExecute),
            ("testGetActivityWithIDReturnsActivitiesOnSuccess", testGetActivityWithIDReturnsActivitiesOnSuccess),
            ("testGetActivityWithIDReturnsNilOnFail", testGetActivityWithIDReturnsNilOnFail),
            ("testGetActivitiesCallsExecute", testGetActivitiesCallsExecute),
            ("testGetActivitiesReturnsActivitiesOnSuccess", testGetActivitiesReturnsActivitiesOnSuccess),
            ("testGetActivitiesReturnsNilOnFail", testGetActivitiesReturnsNilOnFail)
        ]
    }
}
#endif
