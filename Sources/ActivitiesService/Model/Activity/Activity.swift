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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        var dict = [String: Any]()
        let nilString: String? = nil
        let nilInt: Int? = nil
        let nilDate: Date? = nil

        dict["id"] = id != nil ? id : nilString
        dict["name"] = name != nil ? name : nilString
        dict["emoji"] = emoji != nil ? emoji : nilString

        dict["description"] = description != nil ? description : nilString
        dict["genre"] = genre != nil ? genre : nilString

        dict["min_participants"] = minParticipants != nil ? minParticipants : nilInt
        dict["max_participants"] = maxParticipants != nil ? maxParticipants : nilInt

        dict["created_at"] = createdAt != nil ? dateFormatter.string(from: createdAt!) : nilDate
        dict["updated_at"] = updatedAt != nil ? dateFormatter.string(from: updatedAt!) : nilDate

        return JSON(dict)
    }
}

// MARK: - Activity (MySQLRow)

extension Activity {
    func toMySQLRow() -> ([String: Any]) {
        var data = [String: Any]()

        if let name = name {
            data["name"] = name
        }

        if let emoji = emoji {
            data["emoji"] = emoji
        }

        if let description = description {
            data["description"] = description
        }

        if let genre = genre {
            data["genre"] = genre
        }

        if let minParticipants = minParticipants {
            data["min_participants"] = minParticipants
        }

        if let maxParticipants = maxParticipants {
            data["max_participants"] = maxParticipants
        }

        return data
    }
}

// MARK: - Activity (Validate)

extension Activity {
    public func validate() -> [String] {
        var missingParameters = [String]()

        if name == nil {
            missingParameters.append("name")
        }

        if emoji == nil {
            missingParameters.append("emoji")
        }

        if description == nil {
            missingParameters.append("description")
        }

        if genre == nil {
            missingParameters.append("genre")
        }

        if minParticipants == nil {
            missingParameters.append("min_participants")
        }

        if maxParticipants == nil {
            missingParameters.append("max_participants")
        }

        return missingParameters
    }
}
