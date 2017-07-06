import Foundation
import Kitura
import SwiftKuery
import SwiftKueryMySQL
import ActivitiesService

// Create a new router
let router = Router()

var poolOptions = ConnectionPoolOptions(initialCapacity: 1)
let connectionPool =  MySQLConnection.createPool(url: URL(string: "")!, poolOptions: poolOptions)

let handlers = Handlers(connectionPool: connectionPool)

// Handle HTTP GET requests to /
router.get("/activities", handler: handlers.getActivities)

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
