import Foundation
import XCTest
import KituraNet
import SwiftKuery

@testable import KituraHTTPTest
@testable import Kitura
@testable import ActivitiesService
@testable import SwiftKueryMock

/*
  HandlersTests verify if the `Handlers` object functions correctly.
*/
public class HandlersTests: XCTestCase {

    // MARK: from Kitura
    var routerRequest: RouterRequest? // Request to server
    var routerResponse: RouterResponse? // Response from server

    // MARK: from ActivitiesService
    var handlers: Handlers? // Request handler

    // MARK: from SwiftKueryMock (Nic Jackson)
    var connection: MockSQLConnection?
    var connectionPool: ConnectionPool?

    // MARK: from KituraHTTPTest (Nic Jackson)
    var request: Request? // A stubbed request
    var responseRecorder: ResponseRecorder? // A stubbed response that is "captured" instead of being output to the requester and stored in an internal buffer; this enables us to test responses

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

        // If the method is unsupported, then the response status should be set to badRequest
        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertEqual(HTTPStatusCode.badRequest, responseRecorder?.statusCode)
    }

    func testQueriesDataBaseForActivities() throws {
        request!.method = "GET"
        routerRequest = RouterRequest(request: request!)

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertEqual(1, connection!.calls.details["execute"]?.count)
    }

    func testReturnsActivitiesOnSuccessfulQuery() throws {
        // setup
        request!.method = "GET"
        routerRequest = RouterRequest(request: request!)
        // setup expectation on the mock
        connection!.calls.on(method: "execute", withArguments: [MatchAny(), MatchAny()]) {
            arguments in

            let callback = arguments![1] as! ((QueryResult) -> Void)
            callback(.resultSet(ResultSet(TestResultFetcher(numberOfRows: 1))))
        }

        // execute
        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        // assert
        let body = responseRecorder!.jsonBody()
        XCTAssertEqual("abc123", body[0]["id"])
        XCTAssertEqual(HTTPStatusCode.OK,responseRecorder!.statusCode)
    }

    func testReturnsInternalServerErrorOnFailedQuery() throws {
        request!.method = "GET"
        routerRequest = RouterRequest(request: request!)
        connection!.calls.on(method: "execute", withArguments: [MatchAny(), MatchAny()]) {
            arguments in

            let callback = arguments![1] as! ((QueryResult) -> Void)
            callback(.error(QueryError.noResult("Error in query execution.")))
        }

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        let body = responseRecorder!.body()
        XCTAssertEqual("", body)
        XCTAssertEqual(HTTPStatusCode.internalServerError,responseRecorder!.statusCode)
    }

    func testReturnsNotFoundWhenNoActivitiesFromQuery() throws {
        request!.method = "GET"
        routerRequest = RouterRequest(request: request!)

        // because we are not setting the expectation on the mock the callback
        // will never get called and query result will be nil
        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertEqual(HTTPStatusCode.notFound,responseRecorder!.statusCode)
    }
}

#if os(Linux)
extension HandlersTests {
    static var allTests: [(String, (HandlersTests) -> () throws -> Void)] {
        return [
            ("testHTTPVerbsOtherThanGetReturnBadResponse", testHTTPVerbsOtherThanGetReturnBadResponse),
            ("testQueriesDataBaseForActivities", testQueriesDataBaseForActivities),
            ("testReturnsActivitiesOnSuccessfulQuery", testReturnsActivitiesOnSuccessfulQuery),
            ("testReturnsInternalServerErrorOnFailedQuery", testReturnsInternalServerErrorOnFailedQuery),
            ("testReturnsNonFoundWhenNoActivitiesFromQuery", testReturnsNotFoundWhenNoActiviesFromQuery)
       ]
    }
}
#endif
