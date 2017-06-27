import XCTest

@testable import ActivitiesTests
@testable import FunctionalTests

XCTMain([
  testCase(SomeTests.allTests),
  testCase(FunctionalTests.allTests),
  ]
)
