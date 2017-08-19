import Foundation
import SwiftyJSON

// MARK: - Activity

public struct Activity {
    public var id: Int?
    public var name: String?
    public var emoji: String?
    public var description: String?
    public var genre: String?
    public var minParticipants: Int?
    public var maxParticipants: Int?
    public var createdAt: Date?
    public var updatedAt: Date?
}

// MARK: - Activity: JSONAble

extension Activity: JSONAble {
    public func toJSON() -> JSON {
        var dict = [String: Any]()
        let nilValue: Any? = nil

        dict["id"] = id != nil ? id : nilValue
        dict["name"] = name != nil ? name : nilValue
        dict["emoji"] = emoji != nil ? emoji : nilValue
        dict["description"] = description != nil ? description : nilValue
        dict["genre"] = genre != nil ? genre : nilValue
        dict["min_participants"] = minParticipants != nil ? minParticipants : nilValue
        dict["max_participants"] = maxParticipants != nil ? maxParticipants : nilValue

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        dict["created_at"] = createdAt != nil ? dateFormatter.string(from: createdAt!) : nilValue
        dict["updated_at"] = updatedAt != nil ? dateFormatter.string(from: updatedAt!) : nilValue

        return JSON(dict)
    }
}

// MARK: - Activity (MySQLRow)

extension Activity {
    func toMySQLRow() -> ([String: Any]) {
        var data = [String: Any]()

        // UPDATED: Simplified conversion to MySQLRow
        // If a value is nil, then it won't be added to the dictionary
        data["name"] = name
        data["emoji"] = emoji
        data["description"] = description
        data["genre"] = genre
        data["min_participants"] = minParticipants
        data["max_participants"] = maxParticipants

        return data
    }
}

// MARK: - Activity (Validate)

extension Activity {
    public func validateParameters(_ parameters: [String]) -> [String] {
        var missingParameters = [String]()
        let mirror = Mirror(reflecting: self)

        for (name, value) in mirror.children {
            guard let name = name, parameters.contains(name) else { continue }
            if "\(value)" == "nil" {
                missingParameters.append("\(name)")
            }
        }

        return missingParameters
    }
}
