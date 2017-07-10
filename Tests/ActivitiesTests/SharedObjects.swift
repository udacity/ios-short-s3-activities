import Foundation
import SwiftKuery

class TestResultFetcher: ResultFetcher {
    let numberOfRows: Int
    let rows = [
        ["abc123", "Risk", "Test descritption"],
        ["bcd234", "Kill Dr Lucky", "Test descritption"],
        ["cde345", "Snakes and Ladders", "Test descritption"]]
    let titles = ["id", "name", "description"]
    var fetched = 0

    init(numberOfRows: Int) {
        self.numberOfRows = numberOfRows
    }

    func fetchNext() -> [Any?]? {
        if fetched < numberOfRows {
            fetched += 1
            return rows[fetched - 1]
        }
        return nil
    }

    func fetchNext(callback: ([Any?]?) ->()) {
        callback(fetchNext())
    }

    func fetchTitles() -> [String] {
        return titles
    }
}
