import Foundation
import SwiftKuery

public extension QueryResult {
   public func toActivities() -> [Activity] {
      var activities = [Activity]()
       let rows = self.asRows
       for row in rows! {
          activities.append(Activity(id: row["id"] as! String))
      }

      return activities
   }
}

struct SQLResultActivityAdaptor{}
