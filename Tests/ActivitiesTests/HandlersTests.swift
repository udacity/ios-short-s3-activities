import Foundation
import XCTest

@testable import KituraHTTPTest
@testable import Kitura
import KituraNet

public class HandlersTests: XCTestCase {

    var request: Request?
    var responseRecorder: ResponseRecorder?

    var routerRequest: RouterRequest?
    var routerResponse: RouterResponse?

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
    }

    func testSomething() {
        XCTAssertEqual(200,200)
    }

}

#if os(Linux)
extension HandlersTests {
    static var allTests: [(String, (HandlersTests) -> () throws -> Void)] {
        return [
                ("testSomething", testSomething)
        ]
    }
}
#endif
