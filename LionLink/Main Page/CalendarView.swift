import SwiftUI
import Combine

//This is the big boy calendar main view
//Without this the calendar well wouldn't work in the slightest
//Here essentially we call the Top nav bar --> Date selector --> Curr Event timer & Next Event --> Then the view of the selected day
struct CalendarView: View {
    @AppStorage("token") var token: String?
    
    //Loading Data
    @State private var scheduleString: String?
    @State private var individualEventsString: String?
    @State private var isLoading = true
    @Environment(\.colorScheme) var colorScheme
    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
    @State private var selectedEventName: String? = ""
    @State private var groupedEvents: [[Event]] = []
    @State private var individualEvents: [Event] = []
  
    //There may be some not needed variables here, I'm not sure it's been a hot second
    @State private var showingCreateEventView = false
    @State private var selectedIndex: Int = 0
    
    @State private var showingAlert = false
    @State private var selectedEvent: Event?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var centeredDate = Date()
    
    @State private var needsRefresh: Bool = false
    
    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let dataformat = DateFormatter()
        dataformat.dateFormat = "MMMM"
        dataformat.timeZone = TimeZone.current
        return dataformat
    }()
    
    //Sets SelectedIndex based on the current day
    func setSelectedIndexBasedOnDay() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        selectedIndex = (weekday + 5) % 7
    }
    
    func fetchSchedule(completion: @escaping () -> Void) {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // If today is Sunday (weekday 1), set daysToSubtract to 6 to get to the previous Monday.
        // Otherwise, calculate the days to subtract as before.
        let daysToSubtract = (weekday == 1) ? 6 : weekday - calendar.firstWeekday
        let thisMonday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        
            
        let startDateMillis = Int64(thisMonday.timeIntervalSince1970 * 1000) // Convert to milliseconds
        let limit = 7 // Number of days to fetch
        let urlString = "https://hub-dev.stmarksschool.org/v1/student/schedule?startDate=\(startDateMillis)&limit=\(limit)"
        
        print("Fetching schedule with URL: \(urlString)")
        
        fetchFromEndpoint(urlString: urlString) { [self] result in
            switch result {
            case .success(let string):
//                print("Raw response string: \(string)")
                guard let data = string.data(using: .utf8),
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let scheduleArray = json["schedule"] as? [[String: Any]] else {
                    
                    print("Could not parse JSON for schedule")
                    return
                }
                
                print("Received schedule data: \(data)")
                
                print(data)
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
                    }else if(color.elementsEqual("Green")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "1c914f")
                            scheduleEvents.append(event)
                    }else if(color.elementsEqual("Orange")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "f78c34")
                            scheduleEvents.append(event)
                    }else if(color.elementsEqual("Red")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "cf342b")
                            scheduleEvents.append(event)
                    }else if(color.elementsEqual("Plum")){
                        let event = Event(startTime: startTime, endTime: endTime, teacher: teacher, title: title, abbreviatedTitle: abbreviatedTitle, location: location, hex: "a069d6")
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
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // If today is Sunday (weekday 1), set daysToSubtract to 6 to get to the previous Monday.
        // Otherwise, calculate the days to subtract as before.
        let daysToSubtract = (weekday == 1) ? 6 : weekday - calendar.firstWeekday
        let thisMonday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        
            
        let startDateMillis = Int64(thisMonday.timeIntervalSince1970 * 1000) // Convert to milliseconds
        let limit = 7 // Number of days to fetch
        
        let urlString = "https://hub-dev.stmarksschool.org/v1/student/schedule/manual?startDate=\(startDateMillis)&limit=\(limit)"
        fetchFromEndpoint(urlString: urlString) { [self] result in
            switch result {
            case .success(let string):
                print("Raw response string: \(string)")
                guard let data = string.data(using: .utf8),
                      let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Could not parse JSON for individual events")
                    return
                }

                var events: [Event] = []
                for dict in jsonArray {
                    guard let indvId = dict["id"] as? Int,
                          let description = dict["description"] as? String,
                          let color = dict["color"] as? String,
//                          let location = dict["location"] as? String,
                          let startTimeStr = dict["startTime"] as? String,
                          let endTimeStr = dict["endTime"] as? String else {
                        print("Missing data for individual event", dict)
                        continue
                    }
                    
                    
                    let formattedColor = color.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let event = Event(
                        indvId: indvId,
                        startTime: startTimeStr,
                        endTime: endTimeStr,
                        title: description,
                        location: "location",
                        hex: formattedColor
                    )
                    events.append(event)
                }

                individualEvents.append(contentsOf: events)
                completion() // Call the completion handler
            case .failure(let error):
                print("Error fetching individual events: \(error.localizedDescription)")
            }
        }
    }

    
    func fetchFromEndpoint(urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication token is missing"])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let rawResponseString = String(data: data!, encoding: .utf8) {
                print("Response data string:\n\(rawResponseString)")
            }
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
    
    
    //this function below
    private func deleteEvent(event: Event) {
        guard let eventID = event.indvId else {
            print("Event does not have a valid ID")
            return
        }
        
        guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/student/schedule/manual/\(eventID)"),
              let token = self.token else {
            print("Invalid URL or Token is nil")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                needsRefresh = true
                if let error = error {
                    print("Error when trying to delete event: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        print("Successfully deleted event with ID: \(eventID)")
                         
                    } else {
                        print("Failed to delete the event with status code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }




    
    func groupEventsByCurrentWeek(events: [Event]) -> [[Event]] {
        var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
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

    func findCurrentEvent() -> Event? {
        let now = Date()
        
        // Ensure the selectedIndex is within the bounds of groupedEvents
        guard groupedEvents.indices.contains(selectedIndex) else {
            print("Selected index out of range")
            return nil
        }
        
        let todayEvents = groupedEvents[selectedIndex]
        
        for event in todayEvents {
            if event.startTime <= now && event.endTime > now {
                return event
            }
        }
        return nil
    }
    
    func findNextEvent() -> Event? {
        let now = Date()
        
        // Ensure the selectedIndex is within the bounds of groupedEvents
        guard groupedEvents.indices.contains(selectedIndex) else {
            print("Selected index out of range")
            return nil
        }
        
        let todayEvents = groupedEvents[selectedIndex].filter { $0.startTime > now }
        
        // If there are events left in the day, return the first one after the current time
        if let nextEvent = todayEvents.sorted(by: { $0.startTime < $1.startTime }).first {
            return nextEvent
        } else {
            // No more events for today
            return nil
        }
    }
    
    private func loadData() {
        individualEvents.removeAll()
        fetchSchedule {
            fetchIndividualEvents {
                groupedEvents = groupEventsByCurrentWeek(events: individualEvents)
                printEventsByDay(eventsByDay: groupedEvents)
                isLoading = false
                needsRefresh = false  // Reset the refresh trigger
            }
        }
        
    }

    
    func printEventsByDay(eventsByDay: [[Event]]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var dayIndex = Calendar.current.component(.weekday, from: Date())
        
        for dailyEvents in eventsByDay {
            // Check to wrap around the daysOfWeek array if dayIndex exceeds its bounds
            if dayIndex >= daysOfWeek.count {
                dayIndex = 0
            }
            
            print("\(daysOfWeek[dayIndex]):")
            if dailyEvents.isEmpty {
                print("")
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
            if colorScheme == .dark {
                ZStack {
                    VStack {
                        CalendarNavBar(month: monthFormatter.string(from: centeredDate))
                        DateSelectorView(selectedDayIndex: $selectedIndex)
                        Divider().colorInvert()
                        
                        TabView {
                            HStack(spacing: 20) {
                                if let currentEvent = findCurrentEvent() {
                                    TimerView(startTime: currentEvent.startTime, endTime: currentEvent.endTime, name: currentEvent.abbreviatedTitle ?? currentEvent.title, color: Color(hex: currentEvent.colorHex))
                                }
                                if let nextEvent = findNextEvent() {
                                    // Display next event details
                                    NextEvent(eventName: nextEvent.title, backgroundColor: Color(hex: nextEvent.colorHex), startTime: formatTime(nextEvent.startTime), endTime: formatTime(nextEvent.endTime))
                                } else {
                                    Text("No More Events For Today")
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                
                            }
                            .padding(.horizontal, 10)
                            .tag(0)
                            
                            Text("Clubs Will Be Here")
                                .padding(.horizontal, 10)
                                .tag(1)
                            
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 200)
                        Divider().colorInvert()
                        DayEventView(selectedIndex: $selectedIndex, showingCreateEventView: $showingCreateEventView, selectedEvent: $selectedEvent ,onDelete: deleteEvent, eventsByDay: groupedEvents, token: $token)
                    }
                    .overlay(
                        // Only show the EventDetailView if selectedEvent is not nil
                        selectedEvent != nil ? EventDetailView(event: selectedEvent!, onDismiss: { selectedEvent = nil }, onDelete: { deleteEvent(event: selectedEvent!) }) : nil
                    )
                    .onReceive(timer) { _ in
                    }
                    .sheet(isPresented: $showingCreateEventView) {
                        CreateEventView(needsRefresh: $needsRefresh, token: token!)
                    }
                    .onChange(of: needsRefresh) { newValue in
                        if newValue {
                            loadData()
                        }
                    }
                    if isLoading {
                        ProgressView("Loading…")
                            .scaleEffect(1.5, anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.45))
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .onAppear {
                    setSelectedIndexBasedOnDay()
                    if needsRefresh {
                        loadData()
                        needsRefresh = false
                    } else {
                        loadData()
                    }
                }
                } else {
                    ZStack {
                        VStack {
                            CalendarNavBar(month: monthFormatter.string(from: centeredDate))
                            DateSelectorView(selectedDayIndex: $selectedIndex)
                            
                            Divider()
                            
                            TabView {
                                HStack(spacing: 20) {
                                    if let currentEvent = findCurrentEvent() {
                                        TimerView(startTime: currentEvent.startTime, endTime: currentEvent.endTime, name: currentEvent.abbreviatedTitle ?? currentEvent.title, color: Color(hex: currentEvent.colorHex))
                                    } else{
                                        if let nextEvent = findNextEvent() {
                                            TimerView(startTime: nextEvent.startTime, endTime: nextEvent.endTime, name: "next event", color: Color(hex: nextEvent.colorHex))
                                        }
                                    }
                                    if let nextEvent = findNextEvent() {
                                        NextEvent(eventName: nextEvent.title, backgroundColor: Color(hex: nextEvent.colorHex), startTime: formatTime(nextEvent.startTime), endTime: formatTime(nextEvent.endTime))
                                    } else {
                                        Text("No More Events For Today")
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    
                                }
                                .padding(.horizontal, 10)
                                .tag(0)
                                
                                Text("Clubs Will Be Here")
                                    .padding(.horizontal, 10)
                                    .tag(1)
                                
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 200)
                            Divider()
                            DayEventView(selectedIndex: $selectedIndex, showingCreateEventView: $showingCreateEventView, selectedEvent: $selectedEvent ,onDelete: deleteEvent, eventsByDay: groupedEvents, token: $token)
                        }
                        .overlay(
                            Group {
                                if let event = selectedEvent {
                                    EventDetailView(event: event, onDismiss: {
                                        withAnimation {
                                            selectedEvent = nil
                                        }
                                    }, onDelete: {
                                        deleteEvent(event: event)
                                        selectedEvent = nil
                                    })
                                }
                            }
                        )
                        .onReceive(timer) { _ in
                        }
                        .sheet(isPresented: $showingCreateEventView) {
                            CreateEventView(needsRefresh: $needsRefresh, token: token!)
                        }
                        .onChange(of: needsRefresh) { newValue in
                            if newValue {
                                loadData()
                            }
                        }
                        if isLoading {
                            ProgressView("Loading…")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black.opacity(0.45))
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                    .onAppear {
                        setSelectedIndexBasedOnDay()
                        if needsRefresh {
                                loadData()
                               needsRefresh = false
                           } else {
                               loadData()
                           }
                    }
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


extension View {
    @ViewBuilder func isVisible(_ shouldShow: Bool) -> some View {
        switch shouldShow {
        case true: self
        case false: self.hidden()
        }
    }
}
