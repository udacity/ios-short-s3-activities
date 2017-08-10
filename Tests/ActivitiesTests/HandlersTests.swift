import Foundation
import XCTest
import KituraNet

@testable import KituraHTTPTest
@testable import Kitura
@testable import ActivitiesService
@testable import MySQL

/*
  HandlersTests verify if the `Handlers` object functions correctly.
*/
public class HandlersTests: XCTestCase {

    // MARK: from Kitura
    var routerRequest: RouterRequest? // Request to server
    var routerResponse: RouterResponse? // Response from server

    // MARK: from ActivitiesService
    var handlers: Handlers? // Request handler

    // MARK: from SwiftMySQL (Nic Jackson)
    var connection: MockMySQLConnection?
    var connectionPool: MockMySQLConnectionPool?

    // MARK: from KituraHTTPTest (Nic Jackson)
    var request: Request? // A stubbed request
    // A stubbed response that is "captured" instead of being output to the 
    // requester and stored in an internal buffer; this enables us to test responses
    var responseRecorder: ResponseRecorder? 

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

        connection = MockMySQLConnection()

        let connectionString = MySQLConnectionString(host: "127.0.0.1")
        connectionPool = MockMySQLConnectionPool(connectionString: connectionString,
                                                  poolSize: 1,
                                                  defaultCharset: "utf8")
        connectionPool!.getConnectionReturn = connection

        handlers = Handlers(connectionPool: connectionPool!)
    }

    func testQueriesDataBaseForActivities() throws {
        routerRequest = RouterRequest(request: request!)

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        XCTAssertTrue(connection!.executeBuilderCalled)
    }

    func testReturnsActivitiesOnSuccessfulQuery() throws {
        // setup
        routerRequest = RouterRequest(request: request!)
        
        // setup expectation on the mock
        let mockResult = MockMySQLResult()
        mockResult.results = [["id": 123 as Any]]
        connection!.executeMySQLResultReturn = mockResult

        // execute
        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        // assert
        let body = responseRecorder!.jsonBody()
        XCTAssertEqual(123, body[0]["id"])
        XCTAssertEqual(HTTPStatusCode.OK,responseRecorder!.statusCode)
    }

    func testReturnsInternalServerErrorOnFailedQuery() throws {
        routerRequest = RouterRequest(request: request!)
        
        // setup expectation on the mock
        connection!.executeMySQLErrorReturn = .UnableToExecuteQuery(message: "oops")

        try handlers!.getActivities(request: routerRequest!, response: routerResponse!){}

        let body = responseRecorder!.body()
        XCTAssertEqual("", body)
        XCTAssertEqual(HTTPStatusCode.internalServerError,responseRecorder!.statusCode)
    }

    func testReturnsNotFoundWhenNoActivitiesFromQuery() throws {
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
            ("testQueriesDataBaseForActivities", testQueriesDataBaseForActivities),
            ("testReturnsActivitiesOnSuccessfulQuery", testReturnsActivitiesOnSuccessfulQuery),
            ("testReturnsInternalServerErrorOnFailedQuery", testReturnsInternalServerErrorOnFailedQuery),
            ("testReturnsNonFoundWhenNoActivitiesFromQuery", testReturnsNotFoundWhenNoActiviesFromQuery)
       ]
    }
}
#endif
