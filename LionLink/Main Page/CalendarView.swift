import SwiftUI
import Combine

struct CalendarView: View {
//    var token: String
    
    // State variable for the currently centered date.
    @AppStorage("token") var token: String?
    @AppStorage("profileImageData") var profileImageData: Data?
    
    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
    @State private var selectedEventName: String? = ""
    @State private var isPanelShown: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var centeredDate = Date()
    @State private var currentDate = Date()
    
 
    // Function to toggle the panel
        private func togglePanel() {
            isPanelShown.toggle()
        }
    
    // DateFormatter for displaying day numbers.
    private var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df
    }()
    
    var currentEvent: Event? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let currentTime = formatter.date(from: formatter.string(from: currentDate)) ?? Date()

        return events.first(where: { event in
            if let startTime = formatter.date(from: event.startTime),
               let endTime = formatter.date(from: event.endTime) {
                return currentTime >= startTime && currentTime <= endTime
            }
            return false
        })
    }
    
    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()
    
    
    // An array of arrays to hold events for each day of the week.
    // Each inner array represents the events for one specific day.
    private var weeklyEvents: [[Event]] = [
                
                    //Sunday
                [],
        
        
        
                    //Monday
                [Event(id: 1, name: "English", startTime: "8:00", endTime: "9:20", color: Color.green),
                 Event(id: 2, name: "JCI", startTime: "9:25", endTime: "10:10", color: Color.pink),
                 Event(id: 3, name: "Advisory", startTime: "10:15", endTime: "10:55", color: Color.purple),
                 Event(id: 4, name: "Free", startTime: "11:00", endTime: "12:20", color: Color.red),
                 Event(id: 5, name: "Lunch", startTime: "12:20", endTime: "12:50", color: Color.purple),
                 Event(id: 6, name: "Community Block", startTime: "13:00", endTime: "13:40", color: Color.purple),
                 Event(id: 7, name: "History Fellow", startTime: "13:45", endTime: "15:05", color: Color.orange),
                 Event(id: 8, name: "Soccer Practice", startTime: "15:30", endTime: "17:00", color: Color.purple)],
                
                    //Tuesday
                [Event(id: 1, name: "Chapel", startTime: "8:00", endTime: "8:25", color: Color.purple),
                 Event(id: 2, name: "Bio", startTime: "8:30", endTime: "9:50", color: Color.blue),
                 Event(id: 3, name: "English", startTime: "9:55", endTime: "10:40", color: Color.green),
                 Event(id: 4, name: "X-Block", startTime: "10:40", endTime: "11:00", color: Color.purple),
                 Event(id: 5, name: "JCI", startTime: "11:00", endTime: "12:20", color: Color.pink),
                 Event(id: 6, name: "Lunch", startTime: "12:25", endTime: "12:50", color: Color.orange),
                 Event(id: 7, name: "Computer Science", startTime: "12:55", endTime: "13:40", color: Color.brown),
                 Event(id: 8, name: "Calc AB", startTime: "13:45", endTime: "15:05", color: Color.yellow),
                 Event(id: 9, name: "Soccer Practice", startTime: "15:30", endTime: "17:00", color: Color.purple)],
                
                
                    //Wednesday
                [Event(id: 1, name: "History Fellow", startTime: "8:00", endTime: "9:20", color: Color.orange),
                 Event(id: 2, name: "Free", startTime: "9:25", endTime: "10:10", color: Color.red),
                 Event(id: 3, name: "School Meeting", startTime: "10:15", endTime: "10:35", color: Color.purple),
                 Event(id: 4, name: "Computer Science", startTime: "10:40", endTime: "12:00", color: Color.brown),
                 Event(id: 5, name: "Lunch", startTime: "12:00", endTime: "12:30", color: Color.purple),
                 Event(id: 6, name: "Bio", startTime: "12:30", endTime: "13:15", color: Color.blue),
                 Event(id: 7, name: "Soccer Practice", startTime: "13:45", endTime: "15:15", color: Color.purple)],
                
                
                    //Thursday
                [Event(id: 1, name: "Calc AB", startTime: "8:00", endTime: "9:20", color: Color.yellow),
                 Event(id: 2, name: "History Fellow", startTime: "9:25", endTime: "10:10", color: Color.orange),
                 Event(id: 3, name: "Calc AB", startTime: "10:15", endTime: "10:55", color: Color.purple),
                 Event(id: 4, name: "JCI", startTime: "11:00", endTime: "12:20", color: Color.pink),
                 Event(id: 5, name: "Seated Meal", startTime: "12:25", endTime: "12:55", color: Color.purple),
                 Event(id: 6, name: "Community Block", startTime: "13:00", endTime: "13:40", color: Color.purple),
                 Event(id: 7, name: "English", startTime: "13:45", endTime: "15:05", color: Color.green),
                 Event(id: 8, name: "Soccer Practice", startTime: "15:30", endTime: "17:00", color: Color.purple)],
                
                
                    //Friday
                [Event(id: 1, name: "Chapel", startTime: "8:00", endTime: "8:25", color: Color.green),
                 Event(id: 2, name: "Free", startTime: "8:30", endTime: "9:50", color: Color.red),
                 Event(id: 3, name: "Calc AB", startTime: "9:55", endTime: "10:40", color: Color.yellow),
                 Event(id: 4, name: "X-Block", startTime: "10:40", endTime: "11:00", color: Color.pink),
                 Event(id: 5, name: "Bio", startTime: "11:00", endTime: "12:20", color: Color.blue),
                 Event(id: 6, name: "Lunch", startTime: "12:20", endTime: "12:50", color: Color.orange),
                 Event(id: 7, name: "Community Block", startTime: "12:55", endTime: "13:35", color: Color.pink),
                 Event(id: 8, name: "CS", startTime: "13:40", endTime: "15:05", color: Color.brown),
                 Event(id: 9, name: "Soccer Practice", startTime: "15:30", endTime: "17:00", color: Color.pink)],
                
                
                    //Saturday
                []
            ]
        
     
    
 
    private var events: [Event] {
        let dayIndex = Calendar.current.component(.weekday, from: centeredDate) - 1 // Sunday = 1, so subtract 1 to align with array indexing.
        
        return weeklyEvents[dayIndex]
    }
    

    var body: some View {
        VStack {

            NavBar(month: monthFormatter.string(from: centeredDate))
//
//            // Date selector view.
            DateSelector(centeredDate: $centeredDate, dateFormatter: dateFormatter)
            Divider()
            DayScheduleView(events: events, isPanelShown: $isPanelShown, togglePanel: togglePanel, selectedEventName: $selectedEventName)


        }.onReceive(timer) { _ in
            currentDate = Date() // Update the currentDate every second.
        }
        .overlay(
            Group {
                if isPanelShown {
                    // Faded background
                    Rectangle()
                        .fill(Color.black.opacity(0.4))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            // Hide panel when the background is tapped
                            isPanelShown = false
                        }
                    
                    // Panel in the center of the screen
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                // Hide panel when the 'x' button is tapped
                                isPanelShown = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding()
                            }
                        }
                        Text(selectedEventName ?? "hehehehehe")
                            .padding()
                        Spacer()
                    }
                    .frame(width: 350, height: 250) // Medium-sized rectangle
                    .background(Color.white)
                    .cornerRadius(20) // Optional: Add rounded corners to the panel
                }
            }
        )





    }
    
    
    
}

