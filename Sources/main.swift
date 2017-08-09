import Kitura
import LoggerAPI
import HeliumLogger
import Foundation
import ActivitiesService
import MySQL

// Disable stdout buffering (so log will appear)
setbuf(stdout, nil)

// Init logger
HeliumLogger.use(.info)

// Create connection string (use env variables, if exists)
let env = ProcessInfo.processInfo.environment
var connectionString = MySQLConnectionString(host: "172.17.0.2")
connectionString.port = 3306
connectionString.user = "root"
connectionString.password = "password"
connectionString.database = "game_night"

// Create connection pool
var pool = MySQLConnectionPool(connectionString: connectionString, poolSize: 10, defaultCharset: "utf8mb4")

// Get a connection, insert a dummy activity
do {
    try pool.getConnection() { (connection: MySQLConnectionProtocol) in
        let result = try connection.execute(query: "INSERT INTO activities (name, genre, description, emoji, min_participants, max_participants) VALUES ('New Activity', 'Puzzle', 'A simple dummy game.', '🎲', '2', '4');")
        if result.affectedRows > 0 {
            Log.info("activity inserted")
        } else {
            Log.error("activity not inserted")
        }
    }
} catch {
    Log.error(error.localizedDescription)
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: Router())

// Start the Kitura runloop (this call never returns)
Kitura.run()
