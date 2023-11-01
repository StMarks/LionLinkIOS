import SwiftUI

struct Event: Identifiable, Equatable {
    var id: Int
    
    let name: String
    let startTime: String
    let endTime: String
    let color: Color
//    let teacher: String
//    let location: String
    
    
    var startDateTime: Date? {
        return date(from: startTime)
    }

    var endDateTime: Date? {
        return date(from: endTime)
    }

    private func date(from time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.date(from: time)
    }
}
