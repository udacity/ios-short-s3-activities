import XCTest

@testable import ActivitiesTests
@testable import FunctionalTests

XCTMain([
    testCase(HandlersTests.allTests),
    testCase(QueryResultAdaptorTests.allTests),
    testCase(ActivityMySQLDataAccessorTests.allTests),
    testCase(FunctionalTests.allTests)
  ]
)
