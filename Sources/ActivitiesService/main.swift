import Kitura

// Create a new router
let router = Router()

let handlers = Handlers()

// Handle HTTP GET requests to /
router.get("/activities", handler: handlers.getActivities)

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
