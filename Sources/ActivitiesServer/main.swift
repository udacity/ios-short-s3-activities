import Kitura
import LoggerAPI
import HeliumLogger
import Foundation
import SwiftKuery
import SwiftKueryMySQL
import ActivitiesService

// Disable stdout buffering (so log will appear)
setbuf(stdout, nil)

// Init logger
HeliumLogger.use()

// MYSQL_CONNECTION = mysql://user:password@host:port/database
let connectionString = ProcessInfo.processInfo.environment["MYSQL_CONNECTION"]
let poolOptions = ConnectionPoolOptions(initialCapacity: 1)

// Create connection pool
// TODO: monitor connection; if not connected, re-try/log errors/etc.
let connectionPool = MySQLConnection.createPool(url: URL(string: connectionString!)!, poolOptions: poolOptions)
let handlers = Handlers(connectionPool: connectionPool)

// Create router
let router = Router()

// Handle HTTP GET requests to /
router.get("/activities", handler: handlers.getActivities)

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
