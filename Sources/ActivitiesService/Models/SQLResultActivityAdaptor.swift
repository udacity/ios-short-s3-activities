import Foundation
import SwiftKuery

public extension QueryResult {
   public func toActivities() -> [Activity] {
      var activities = [Activity]()
       if let rows = self.asRows {
           for row in rows {
               var activity = Activity()

               if let id = row["id"] as? String {
                   activity.id = id
               }

               if let name = row["name"] as? String {
                   activity.name = name
               }

               if let description = row["description"] as? String {
                   activity.description = description
               }

               if let maxParticipants = row["maxParticipants"] as? Int? {
                   activity.maxParticipants = maxParticipants
               }

               activities.append(activity)
           }
       }

      return activities
   }
}

struct SQLResultActivityAdaptor {}
