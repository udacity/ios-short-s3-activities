import MySQL
import LoggerAPI
import Foundation

// MARK: - MySQLResultProtocol (Activity)

public extension MySQLResultProtocol {

    public func toActivities() -> [Activity] {

        var activities = [Activity]()

        while case let row? = self.nextResult() {

            var activity = Activity()

            activity.id = row["id"] as? Int
            activity.minParticipants = row["min_participants"] as? Int
            activity.maxParticipants = row["max_participants"] as? Int
            activity.name = row["name"] as? String
            activity.emoji = row["emoji"] as? String
            activity.genre = row["genre"] as? String
            activity.description = row["description"] as? String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            if let createdAtString = row["created_at"] as? String,
               let createdAt = dateFormatter.date(from: createdAtString) {
                   activity.createdAt = createdAt
            }

            if let updatedAtString = row["updated_at"] as? String,
               let updatedAt = dateFormatter.date(from: updatedAtString) {
                   activity.updatedAt = updatedAt
            }

            activities.append(activity)
        }

        return activities
    }
}
