import Foundation
import LoggerAPI

// MARK: - MySQLResultProtocol (Activity)

public extension MySQLResultProtocol {

    public func toActivities() -> [Activity] {

        var activities = [Activity]()

        while case let row? = self.nextResult() {

            var activity = Activity()

            if let id = row["id"] as? Int {
                activity.id = Int(id)
            }

            if let minParticipants = row["min_participants"] as? Int {
                activity.minParticipants = Int(minParticipants)
            }

            if let maxParticipants = row["max_participants"] as? Int {
                activity.maxParticipants = Int(maxParticipants)
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            if let createdAtString = row["created_at"] as? String, let createdAt = dateFormatter.date(from: createdAtString) {
                activity.createdAt = createdAt
            }

            if let updatedAtString = row["updated_at"] as? String, let updatedAt = dateFormatter.date(from: updatedAtString) {
                activity.updatedAt = updatedAt
            }

            if let name = row["name"] as? String {
                activity.name = name
            }

            if let emoji = row["emoji"] as? String {
                activity.emoji = emoji
            }

            if let genre = row["genre"] as? String {
                activity.genre = genre
            }

            if let description = row["description"] as? String {
                activity.description = description
            }

            activities.append(activity)
        }

        return activities
    }
}
