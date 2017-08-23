import ActivitiesService

class MockActivityDataAccessor: ActivityMySQLDataAccessorProtocol {
    var createActivityReturn: Bool = false
    var createActivityError: Error?
    var createActivityCalled: Bool = false

    var updateActivityReturn: Bool = false
    var updateActivityError: Error?
    var updateActivityCalled: Bool = false

    var deleteActivityReturn: Bool = false
    var deleteActivityError: Error?
    var deleteActivityCalled: Bool = false

    var getActivityReturn: [Activity]?
    var getActivityError: Error?
    var getActivityCalled: Bool = false

    func createActivity(_ activity: Activity) throws -> Bool {
        createActivityCalled = true

        if let err = createActivityError {
            throw err
        }

        return createActivityReturn
    }

    func updateActivity(_ activity: Activity) throws -> Bool {
        updateActivityCalled = true

        if let err = updateActivityError {
            throw err
        }

        return updateActivityReturn
    }

    func deleteActivity(withID id: String) throws -> Bool {
        deleteActivityCalled = true

        if let err = deleteActivityError {
            throw err
        }

        return deleteActivityReturn
    }

    func getActivities(withID id: String, maxSize: Int = 10, offset: Int64 = 0) throws -> [Activity]? {
        getActivityCalled = true

        if let err = getActivityError {
            throw err
        }

        return getActivityReturn
    }

    func getActivities(maxSize: Int = 10, offset: Int64 = 0) throws -> [Activity]? {
        getActivityCalled = true

        if let err = getActivityError {
            throw err
        }

        return getActivityReturn
    }
}
