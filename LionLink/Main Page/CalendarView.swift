import SwiftUI
import Combine

struct CalendarView: View {
//    var token: String
    @AppStorage("token") var token: String?
    
    //Loading Data
    @State private var scheduleString: String?
    @State private var individualEventsString: String?
    @State private var isLoading = true
    
    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
    @State private var selectedEventName: String? = ""
    
    @State private var groupedEvents: [[Event]] = []
    @State private var individualEvents: [Event] = []
  
    @State private var isPanelShown: Bool = false
    
    @State private var showingCreateEventView = false
    @State private var selectedIndex: Int = 1
    
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var centeredDate = Date()
    
    
    private func togglePanel() {
        isPanelShown.toggle()
    }
    
    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()
    
    
    func fetchSchedule(completion: @escaping () -> Void) {
        let urlString = "https://hub-dev.stmarksschool.org/v1/student/schedule?limit=3"
        fetchFromEndpoint(urlString: urlString) { [self] result in
            switch result {
            case .success(let string):
                guard let data = string.data(using: .utf8),
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let scheduleArray = json["schedule"] as? [[String: Any]] else {
                    print("Could not parse JSON for schedule")
                    return
                }
                
                var scheduleEvents: [Event] = []
                for dict in scheduleArray {
                    guard let startTime = dict["startTime"] as? String,
                          let endTime = dict["endTime"] as? String,
                          let title = dict["title"] as? String,
                          let teacher = dict["teacher"] as? String,
                          let abbreviatedTitle = dict["abbreviatedTitle"] as? String,
                          let location = dict["location"] as? String,
                          let color = dict["color"] as? String else {
                        print("Missing data for schedule event")
                        continue
                    }
                    
                    print(color.lowercased())
                    if(color=="Yellow"){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "FFEA00")
                            scheduleEvents.append(event)
                    }else if(color.elementsEqual("Blue")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "89CFF0")
                            scheduleEvents.append(event)
                    }else if(color.elementsEqual("Brown")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "7B3F00")
                            scheduleEvents.append(event)
                    }else{
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "023020")
                            scheduleEvents.append(event)
                    }
                }
                
                individualEvents.append(contentsOf: scheduleEvents)
                completion() // Call the completion handler
            case .failure(let error):
                print("Error fetching schedule: \(error.localizedDescription)")
            }
        }
    }


    func fetchIndividualEvents(completion: @escaping () -> Void) {
        let urlString = "https://hub-dev.stmarksschool.org/v1/student/schedule/manual"
        fetchFromEndpoint(urlString: urlString) { [self] result in
            switch result {
            case .success(let string):
                guard let data = string.data(using: .utf8),
                      let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Could not parse JSON for individual events")
                    return
                }

                var events: [Event] = []
                for dict in jsonArray {
                    guard let startTime = dict["startTime"] as? String,
                          let endTime = dict["endTime"] as? String,
                          let description = dict["description"] as? String,
                          let color = dict["color"] as? String else {
                        print("Missing data for individual event")
                        continue
                    }
                    let location = "Not specified" // Use a default value for location
                    let event = Event(startTime: startTime, endTime: endTime, title: description, location: location, hex: color)
                    events.append(event)
                }

                individualEvents.append(contentsOf: events)
                completion() // Call the completion handler
            case .failure(let error):
                print("Error fetching individual events: \(error.localizedDescription)")
            }
        }
    }



    // fetchFromEndpoint remains the same
    func fetchFromEndpoint(urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Unwrap the token safely before adding it to the request header
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    completion(.success(string))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            }
        }.resume()
    }

    
    func groupEventsByCurrentWeek(events: [Event]) -> [[Event]] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 5 * 60 * 60) ?? calendar.timeZone // Adjust for the timezone (+5 hours)
        calendar.firstWeekday = 2 // Week starts on Monday

        // Find the start of the current week
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            fatalError("Couldn't calculate the start of the current week.")
        }

        // Find the end of the current week
        guard let endOfWeek = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
            fatalError("Couldn't calculate the end of the current week.")
        }

        // Filter events that occur within the current week
        let eventsThisWeek = events.filter { event in
            event.startTime >= weekStart && event.startTime < endOfWeek
        }

        // Create an array to hold events for each day of the week
        var daysArray: [[Event]] = Array(repeating: [], count: 7)

        // Assign events to the corresponding day
        for event in eventsThisWeek {
            let dayOffset = calendar.dateComponents([.day], from: weekStart, to: event.startTime).day ?? 0
            daysArray[dayOffset].append(event)
        }

        // Sort the events for each day
        for i in 0..<daysArray.count {
            daysArray[i].sort(by: { $0.startTime < $1.startTime })
        }

        return daysArray
    }


    
    func printEventsByDay(eventsByDay: [[Event]]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var dayIndex = Calendar.current.component(.weekday, from: Date()) - 1 // Adjust for your calendar if needed
        
        for dailyEvents in eventsByDay {
            // Check to wrap around the daysOfWeek array if dayIndex exceeds its bounds
            if dayIndex >= daysOfWeek.count {
                dayIndex = 0
            }
            
            print("\(daysOfWeek[dayIndex]):")
            if dailyEvents.isEmpty {
                print("  No events")
            } else {
                for event in dailyEvents {
                    let startTime = dateFormatter.string(from: event.startTime)
                    let endTime = dateFormatter.string(from: event.endTime)
                    print("  \(event.title) - \(startTime) to \(endTime)")
                    if let teacher = event.teacher {
                        print("    Teacher: \(teacher)")
                    }
                    if let abbreviatedTitle = event.abbreviatedTitle {
                        print("    Abbreviated Title: \(abbreviatedTitle)")
                    }
                    print("    Color: \(event.colorHex)")
                }
            }
            dayIndex += 1
            print("\n") // Add space between days for readability
        }
    }
    
    

        var body: some View {
            VStack {
                CalendarNavBar(month: monthFormatter.string(from: centeredDate))
                DateSelectorView(selectedDayIndex: $selectedIndex)
                
                Divider() // Remove padding if not needed
                
                TabView {
                    // First page
                    HStack(spacing: 20) { // Remove spacing if not needed
                        TimerView(startTimeString: "13:45", endTimeString: "15:05", name: "Computer Science", color: .brown)
                        NextEvent(eventName: "Done For The Day!", backgroundColor: .pink, startTime: "", endTime: "")
                    }
                    .padding(.horizontal, 10) // Add a little padding if needed, adjust to your preference
                    .tag(0)
                    
                    // Second page (replace with your actual other view)
                    Text("Clubs")
                        .padding(.horizontal, 10) // Same padding for consistency
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                 .frame(height: 200) 
                
                DayEventView(selectedIndex: $selectedIndex, showingCreateEventView: $showingCreateEventView ,eventsByDay: groupedEvents)
            }
            .onReceive(timer) { _ in
//                refreshID = UUID() // Force refresh of the view
//                print("heyyyyy")
            }
            .onAppear {
                fetchSchedule {
                    fetchIndividualEvents {
                        // Now the groupEventsByCurrentWeek and printEventsByDay will be called
                        // after both fetchSchedule and fetchIndividualEvents have completed
                        groupedEvents = groupEventsByCurrentWeek(events: individualEvents)
                        printEventsByDay(eventsByDay: groupedEvents)
                    }
                }
            }
            .sheet(isPresented: $showingCreateEventView) {
                CreateEventView(token: token ?? "")
            }
        }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    func findNextEvent(after date: Date, in events: [[Event]]) -> Event? {
        let sortedEvents = events.flatMap { $0 }.sorted { $0.startTime < $1.startTime }
        return sortedEvents.first { $0.startTime > date }
    }
}

