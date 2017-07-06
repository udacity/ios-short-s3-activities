import Foundation

class Models {}

struct Activity {
    var id: String
    var name: String
    var description: String
    var maxParticipants: Int
}

struct Error {
    var code: Int
    var message: String
}
