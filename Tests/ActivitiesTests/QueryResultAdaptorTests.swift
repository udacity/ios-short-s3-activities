import Foundation
import XCTest
import SwiftKuery

public class QueryResultAdaptorTests: XCTestCase {

    public func testSQLResultReturnsActivity() {
        let queryResult = QueryResult.resultSet(ResultSet(TestResultFetcher(numberOfRows: 2)))
        var activities = queryResult.toActivities()
        XCTAssertEqual("abc123", activities[0].id)
    }
}
