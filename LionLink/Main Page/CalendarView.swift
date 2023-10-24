import SwiftUI

struct CalendarView: View {
    // State variable for the currently centered date.
    @State private var centeredDate = Date()
    
    // DateFormatter for displaying day numbers.
    private var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df
    }()
    
    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()
    
    let events: [Event] = [
            Event(name: "Chapel", color: .purple, start: "11:00", end: "13:00")
//            ,
//            Event(name: "Free", color: .green, start: "9:00", end: "10:30"),
//            Event(name: "Biology", color: .blue, start: "11:00", end: "12:30"),
//            Event(name: "Lunch", color: .orange, start: "12:30", end: "13:30"),
//            Event(name: "CS", color: .red, start: "14:00", end: "15:30")
        ]
    
    var body: some View {
        VStack {
//            // The top navigation bar.
            NavBar(month: monthFormatter.string(from: centeredDate))
//                        
//            // Date selector view.
            DateSelector(centeredDate: $centeredDate, dateFormatter: dateFormatter)
//                        
            Divider()
//
//            // Day schedule view.
            DayScheduleView(events: events)

        }
    }
}
