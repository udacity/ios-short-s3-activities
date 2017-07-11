import Foundation
import SwiftyJSON

public struct Activity: JSONAble {
    public var id: String?
    public var name: String?
    public var description: String?
    public var maxParticipants: Int?
}

public extension Activity {
    public func toJSON() -> JSON{
        var dict = [String: Any]()

        if let id = self.id as? String {
            dict["id"] = id
        }

        if let name = self.name as? String {
            dict["name"] = name
        }

        if let description = self.description as? String {
            dict["description"] = description
        }

        if let mp = maxParticipants as? Int {
            dict["maxParticpants"] = mp
        }

        return JSON(dict)
    }
}
