import Foundation
import XCTest
@testable import MySQL

public class QueryResultAdaptorTests: XCTestCase {

    public func testSQLResultReturnsActivity() {
        let queryResult = MockMySQLResult()
        queryResult.results = [["id": 123 as Any]]

        var activities = queryResult.toActivities()
        XCTAssertEqual(123, activities[0].id)
    }
}
