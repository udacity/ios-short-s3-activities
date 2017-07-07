import Foundation
import XCTest

@testable import KituraHTTPTest
@testable import Kitura
@testable import ActivitiesService
@testable import SwiftKueryMock

import KituraNet
import SwiftKuery

public class HandlersTests: XCTestCase {

    var request: Request?
    var responseRecorder: ResponseRecorder?

    var routerRequest: RouterRequest?
    var routerResponse: RouterResponse?

    var handlers: Handlers?
    var connection: MockSQLConnection?
    var connectionPool: ConnectionPool?

    public override func setUp() {
        request = Request()

        var routerStack = Stack<Router>()
        routerStack.push(Router())

        routerRequest = RouterRequest(request: request!)
        responseRecorder = ResponseRecorder()
        routerResponse = RouterResponse(
                response: responseRecorder!,
                routerStack: routerStack,
                request: routerRequest!)

        connection = MockSQLConnection()
        connectionPool = MockSQLConnection.createPool(connection!)

        handlers = Handlers(connectionPool: connectionPool!)
    }

    func testHTTPVerbsOtherThanGetReturnBadResponse() throws {
        request!.method = "POST"
        routerRequest = RouterRequest(request: request!)

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertEqual(HTTPStatusCode.badRequest, responseRecorder?.statusCode)
    }

    func testQueriesDataBaseForActivities() throws {
        request!.method = "GET"
        routerRequest = RouterRequest(request: request!)

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertEqual(1, connection!.calls.details["execute"]?.count)
    }
}

#if os(Linux)
extension HandlersTests {
    static var allTests: [(String, (HandlersTests) -> () throws -> Void)] {
        return [
            ("testHTTPVerbsOtherThanGetReturnBadResponse", testHTTPVerbsOtherThanGetReturnBadResponse),
            ("testQueriesDataBaseForActivities", testQueriesDataBaseForActivities)
        ]
    }
}
#endif
