import SwiftUI
import Combine

struct CalendarView: View {
//    var token: String
    
    // State variable for the currently centered date.
    
    @AppStorage("profileImageData") var profileImageData: Data?
    @AppStorage("token") var token: String?
    
    @State private var scheduleData: ScheduleData?
    
    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
    @State private var selectedEventName: String? = ""
    @State private var isPanelShown: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var centeredDate = Date()
    @State private var currentDate = Date()
    
    let timeZoneIdentifier = "America/New_York" // Set the appropriate time zone identifier
    let timeString = "2023-11-08T12:00:00.000Z"
    
    
 
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

    private var events: [Event] {
        var tempday: [Event] = []
        var count: Int = 1
        if let scheduleData = scheduleData {
            // Use the parsed data to populate your array
            for item in scheduleData.schedule {
                if(isSameDayAndMonth(dateString: extractDayAndMonth(from: item.startTime), currentDate: centeredDate)){
                    
                }
                tempday.append(Event(id: count, startTime: parseTime(from: item.startTime, timeZoneIdentifier: timeZoneIdentifier), endTime: parseTime(from: item.endTime, timeZoneIdentifier: timeZoneIdentifier), teacher: item.teacher, title: item.title, location: item.location, coler: item.color))
                count+=1
            }
        }
      
        
        return tempday
        
    }
    
    func parseTime(from string: String, timeZoneIdentifier: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        
        return "Invalid Date"
    }

    
    func extractDayAndMonth(from string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "dd-MM"
            return dateFormatter.string(from: date)
        }
        
        return "Invalid Date"
    }
    
    func isSameDayAndMonth(dateString: String, currentDate: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        
        let currentDateString = dateFormatter.string(from: currentDate)
        return dateString == currentDateString
    }
    
   
    

    
    
    
    var body: some View {
        
        VStack {
           
            if let scheduleData = scheduleData {
                        
                    } else {
                        Text("Loading...")
                            .onAppear {
                                // Make an HTTP GET request with the JWT token in the request header
                                print(token)
                                guard let url = URL(string: "https://e6c9-96-230-82-137.ngrok-free.app/v1/student/schedule?limit=0") else { return }
                                var request = URLRequest(url: url)
                                if(token == nil) {
                                    // ruh roh
                                    return
                                }
                                request.httpMethod = "GET"
                                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")

                                URLSession.shared.dataTask(with: request) { (data, response, error) in
                                    
                                    if let data = data {
                                        do {
                                            // Parse the JSON response into Swift data structures
                                            
                                            print(token)
                                            let decoder = JSONDecoder()
                                            let decodedData = try decoder.decode(ScheduleData.self, from: data)
                                            DispatchQueue.main.async {
                                                self.scheduleData = decodedData
                                                
                                                for event in self.events {
                                                    event.scheduleNotification()
                                                }
                                            }
                                        } catch {
                                            print("Error decoding JSON: \(error)")
                                        }
                                    }
                                }.resume()
                            }
                    }
            NavBar(month: monthFormatter.string(from: centeredDate))
//            // Date selector view.
            DateSelector(centeredDate: $centeredDate, dateFormatter: dateFormatter)
            Divider()
            
            DayScheduleView(events: events, isPanelShown: $isPanelShown, togglePanel: togglePanel, selectedEventName: $selectedEventName)
        }
        .onReceive(timer) { _ in
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


struct ScheduleData: Codable {
    let scheduleDayLimit: Int
    let user: User
    let schedule: [ScheduleItem]
}
struct User: Codable {
    let firstName: String
    let lastName: String
    let preferredName: String
    let gradYear: Int
    let email: String
}
struct ScheduleItem: Codable, Identifiable {
    let startTime: String
    let endTime: String
    let teacher: String
    let title: String
    let location: String
    let color: String
    var id: String { startTime + title }
}
