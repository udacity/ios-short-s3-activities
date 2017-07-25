import Foundation
import SwiftKuery
import LoggerAPI
import SwiftKueryMySQL

public extension QueryResult {
   public func toActivities() -> [Activity] {

      var activities = [Activity]()
      
       if let rows = self.asRows {
           for row in rows {
               var activity = Activity()

               if let createdAt = row["created_at"] as? Date {
                   activity.createdAt = createdAt
               }

               if let updatedAt = row["updated_at"] as? Date {
                   activity.updatedAt = updatedAt
               }

               if let id = row["id"] as? Int32 {
                   activity.id = Int(id)
               }

               if let name = row["name"] as? String {
                   activity.name = name
               }

               if let genre = row["genre"] as? String {
                   activity.genre = genre
               }

               if let descriptionData = row["description"] as? Data, let description = String(data: descriptionData, encoding: .utf8) {
                   activity.description = description
               }

               if let minParticipants = row["min_participants"] as? Int32 {
                   activity.minParticipants = Int(minParticipants)
               }

               if let maxParticipants = row["max_participants"] as? Int32 {
                   activity.maxParticipants = Int(maxParticipants)
               }

               activities.append(activity)
           }
       }

      return activities
   }
}

struct SQLResultActivityAdaptor {}
