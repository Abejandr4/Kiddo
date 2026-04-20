import Combine
import CloudKit

class CloudKitManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    let publicDB: CKDatabase?
        
        init(isPreview: Bool = false) {
            if isPreview {
                self.publicDB = nil
            } else {
                self.publicDB = CKContainer.default().publicCloudDatabase
            }
        }

    func setupParentAccount(token: String) async throws {
        let recordID = CKRecord.ID(recordName: token)
        let record = CKRecord(recordType: "Tratamiento", recordID: recordID)
        record["status"] = "active" as CKRecordValue
        record["lastUpdate"] = Date() as CKRecordValue
        if let publicDB = publicDB {
            try await publicDB.save(record)
        }
        try await subscribeToChanges(token: token)
    }

    private func subscribeToChanges(token: String) async throws {
        let predicate = NSPredicate(format: "recordID == %@", CKRecord.ID(recordName: token))
        let subscription = CKQuerySubscription(
            recordType: "Tratamiento",
            predicate: predicate,
            subscriptionID: "\(token)_sub",
            options: .firesOnRecordUpdate
        )
        let info = CKSubscription.NotificationInfo()
        info.alertBody = "Se ha registrado una nueva toma de medicamento."
        info.shouldBadge = true
        info.soundName = "default"
        subscription.notificationInfo = info
        if let publicDB = publicDB {
            try await publicDB.save(subscription)
        }
        
    }
}
