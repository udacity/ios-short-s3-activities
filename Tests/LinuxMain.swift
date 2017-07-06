import XCTest

@testable import ActivitiesTests
@testable import FunctionalTests

XCTMain([
  testCase(HandlersTests.allTests),
  testCase(FunctionalTests.allTests)
  ]
)
