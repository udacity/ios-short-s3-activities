import Foundation

public struct Activity {
    public var id: String?
    public var name: String?
    public var description: String?
    public var maxParticipants: Int?

    init(id: String, name: String? = "", description: String? = "", maxParticipants: Int? = 0) {
        self.id = id
        self.name = name
        self.description = description
        self.maxParticipants = maxParticipants
    }
}

