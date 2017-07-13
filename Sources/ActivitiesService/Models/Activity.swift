import Foundation
import SwiftyJSON

// MARK: - Activity

public struct Activity {
    public var id: String?
    public var name: String?
    public var description: String?
    public var maxParticipants: Int?
}

// MARK: - Activity: JSONAble

extension Activity: JSONAble {
    public func toJSON() -> JSON {
        var dict = [String: Any]()

        if let id = self.id {
            dict["id"] = id
        }

        if let name = self.name {
            dict["name"] = name
        }

        if let description = self.description {
            dict["description"] = description
        }

        if let mp = maxParticipants {
            dict["maxParticpants"] = mp
        }

        return JSON(dict)
    }
}
