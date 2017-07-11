import Foundation
import SwiftyJSON

public protocol JSONAble {
    func toJSON() -> JSON
}

public extension Array where Element : JSONAble {
    public func toJSON() -> JSON {
        var json = [JSON]()

        for element in self {
            json.append(element.toJSON())
        }

        return JSON(json)
    }
}
