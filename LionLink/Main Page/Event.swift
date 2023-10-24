import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let start: String
    let end: String
    
    // Helper functions to calculate the position and height of event blocks.
    func startsThisHour(_ hour: Int) -> Bool {
        
        let startHourInt = Int(start.prefix(2)) ?? 0
        return startHourInt == hour
    }
    
    func startHourFraction(from hour: Int) -> CGFloat {
        if let startHourInt = Int(start.prefix(2)), let startMinInt = Int(start.suffix(2)) {
            return CGFloat(startHourInt - hour) + CGFloat(startMinInt) / 60.0
        }
        return 0
    }
    
    func durationInHours() -> CGFloat {
        if let startHourInt = Int(start.prefix(2)), let startMinInt = Int(start.suffix(2)),
           let endHourInt = Int(end.prefix(2)), let endMinInt = Int(end.suffix(2)) {
            return CGFloat(endHourInt - startHourInt) + CGFloat(endMinInt - startMinInt) / 60.0
        }
        return 1
    }
}
