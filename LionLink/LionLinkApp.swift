import SwiftUI
import SafariServices
import UserNotifications


@main
struct LionLinkApp: App {
    init() {
        //Gets permission to send notifications - Use of permission not implemented so not needed. 
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



//Dark and Light mode is only implemented in some parts.
//Log out error description should be on asana + Profile Page(Pfp)
