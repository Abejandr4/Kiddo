import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(for event: CalendarEvent) {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = event.eventDescription ?? "Tienes un evento próximo"
        content.sound = .default
        content.interruptionLevel = .timeSensitive
        content.relevanceScore = 1.0

        // Use event.date directly — no string parsing needed
        let triggerDate = event.date.addingTimeInterval(-1 * 60) // 10 min before
        
        // Don't schedule if the date has already passed
        guard triggerDate > Date() else {
            print("⚠️ Event date already passed, skipping: \(event.title)")
            return
        }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: event.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for \(event.title) at \(triggerDate)")
            }
        }
    }

    func cancelNotification(for event: CalendarEvent) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [event.id.uuidString]
        )
    }
}
