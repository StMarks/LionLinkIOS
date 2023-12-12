import SwiftUI
import SafariServices
import UserNotifications


@main
struct LionLinkApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    init() {
            // Requesting notification permission when the app launches
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                if granted {
                    print("Notification permission granted.")
                } else {
                    print("Notification permission denied.")
                }
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



