import SwiftUI
import UserNotifications

struct Event: Identifiable, Equatable {
    var id: Int
    let startTime: String
    let endTime: String
    let teacher: String
    let title: String
    let location: String
    let coler: String
    
   
    
    
    

    
    var startDateTime: Date? {
        return date(from: startTime)
    }

    var endDateTime: Date? {
        return date(from: endTime)
    }
    
    var color: Color?{
        if(coler.lowercased() == "orange"){
            return Color(.orange)
        }
        if(coler.lowercased() == "blue"){
            return Color(.blue)
        }
        if(coler.lowercased() == "brown"){
            return Color(.brown)
        }
        if(coler.lowercased() == "green"){
            return Color(.green)
        }
        if(coler.lowercased() == "red"){
            return Color(.red)
        }
        if(coler.lowercased() == "yellow"){
            return Color(.yellow)
        }
        if(coler.lowercased() == "plum"){
            return Color(.purple)
        }
        
        return Color(coler.lowercased())
    }
    private func date(from time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.date(from: time)
    }
    
  
}



extension Event {
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.body = "Your event \(title) is starting in 5 minutes."
        content.sound = UNNotificationSound.default

        // Convert start time to Date and subtract 5 minutes
        if let eventDate = startDateTime {
            let triggerDate = Calendar.current.date(byAdding: .minute, value: -5, to: startDateTime!)
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
}
