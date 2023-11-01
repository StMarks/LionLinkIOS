import SwiftUI

// This struct represents the view for displaying daily events on a timeline.
struct DayScheduleView: View {
    // Array of events to display.
    let events: [Event]
    

    @Binding var isPanelShown: Bool
    var togglePanel: () -> Void
    @Binding var selectedEventName: String?

    
    @AppStorage("isDarkMode") public var isDarkMode: Bool?
    
    // Constants for layout calculation.
    private let hourHeight: CGFloat = 60
    private let hoursInDay = 24
    
    // State to keep track of the current date.
    @State private var currentDate = Date()
    
    // Timer to update the view every second.
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Debug variable to force view refresh.
    @State private var refreshID = UUID()
    
    // State to track the event that user taps on.
    @State private var selectedEvent: Event?

    // Function to calculate the Y-position for a given time.
    func positionYFor(time: String) -> CGFloat {
        let components = time.split(separator: ":").compactMap { Int($0) }
        if components.count == 2 {
            let hours = components[0]
            let minutes = components[1]
            return CGFloat(hours) * hourHeight + CGFloat(minutes) / 60.0 * hourHeight
        }
        return 0
    }
    
    // Function to calculate height for an event based on its start and end times.
    func heightFor(startTime: String, endTime: String) -> CGFloat {
        return positionYFor(time: endTime) - positionYFor(time: startTime)
    }

    // Determine the currently ongoing event.
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

    
    // Determine the next event after the current event.
    var nextEvent: Event? {
        let calendar = Calendar.current
        let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        
        let futureEvents = events.filter { event in
            let eventStartTimeComponents = event.startTime.split(separator: ":").compactMap { Int($0) }
            if eventStartTimeComponents.count == 2,
               let eventHour = eventStartTimeComponents.first,
               let eventMinute = eventStartTimeComponents.last,
               let currentHour = currentTimeComponents.hour,
               let currentMinute = currentTimeComponents.minute {
                return (eventHour, eventMinute) > (currentHour, currentMinute)
            }
            return false
        }.sorted { event1, event2 in
            let event1Components = event1.startTime.split(separator: ":").compactMap { Int($0) }
            let event2Components = event2.startTime.split(separator: ":").compactMap { Int($0) }
            return (event1Components.first ?? 0, event1Components.last ?? 0) < (event2Components.first ?? 0, event2Components.last ?? 0)
        }

        return futureEvents.first
    }



    

    // Main body of the DayScheduleView.
    var body: some View {
        HStack{
            // Uncomment below to see the timer view.
            // TimerView(startTime: Date().addingTimeInterval(-60), endTime: Date().addingTimeInterval(240))
            TimerView(startTimeString: currentEvent?.startTime ?? "0:00", endTimeString: currentEvent?.endTime ?? "0:00", name: currentEvent?.name ?? "No Current Class", color: currentEvent?.color ?? .black)
            
            Spacer()
                .frame(width: 25)
            
            // View for the next event.
            NextEvent(eventName: nextEvent?.name ?? "Bio", backgroundColor: nextEvent?.color ?? .black, startTime: nextEvent?.startTime ?? "0:00", endTime: nextEvent?.endTime ?? "0:00")
        }
        .onReceive(timer) { _ in
            currentDate = Date() // Update the currentDate every second.
            refreshID = UUID() // Force refresh of the view
        }
//        .background(isDarkMode ?? false ? Color.black : Color.white)
        
        
        ScrollView(.vertical, showsIndicators: true) {
            ScrollViewReader { reader in
                Divider()

                ZStack(alignment: .leading) {
                    // Time markings on the left.
                    ForEach(0..<hoursInDay*2) { index in
                        Text("\(index / 2):\(index % 2 == 0 ? "00" : "30")")
                            .font(.caption)
                            .frame(width: 60, height: hourHeight/2, alignment: .leading)
                            .position(x: 30, y: CGFloat(index) * (hourHeight / 2))
                    }
                    
                    // Red horizontal line indicating the current time.
                    var currentTime: String {
                        let currentDate = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        return formatter.string(from: currentDate)
                    }
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 3)
                        .position(x: UIScreen.main.bounds.width / 2, y: positionYFor(time: currentTime))
                        .id("redLine") // We're tagging this view so that we can scroll to it
                    
                    // Events displayed as colored blocks.
                    ForEach(events) { event in
                        let eventStartY = self.positionYFor(time: event.startTime)
                            let eventHeight = self.heightFor(startTime: event.startTime, endTime: event.endTime)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(
                                            stops: [
                                                .init(color: event.color, location: 0),
                                                .init(color: event.color, location: 0.2),
                                                .init(color: event.color.opacity(0.8), location: 1)
                                            ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width - 40, height: eventHeight)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                .overlay(
                                    HStack {
                                        Text(event.name)
                                            .font(.headline)
                                            .padding(.leading, 20)
                                        Spacer()
                                        Text("\(event.startTime) - \(event.endTime)")
                                            .font(.footnote)
                                            .padding(.trailing, 20)
                                    }
                                    .foregroundColor(.white)
                                )
                                .position(x: UIScreen.main.bounds.width / 2 + 20, y: eventStartY + eventHeight / 2)
                                .onTapGesture {
                                    isPanelShown.toggle()
                                    selectedEventName = event.name
                                }
 
                        
                    }
                }
                .frame(height: hourHeight * CGFloat(hoursInDay))
            
                .onAppear {
                    // Scroll to the red line's position when the view first appears
                    reader.scrollTo("redLine", anchor: .center)
                }
            }
        }

        .onTapGesture {
                        // Use the passed function to toggle the panel
                        togglePanel()
            
                    }
//        .background(isDarkMode ?? false ? Color.black : Color.white)
    }
    
    
}

extension Date {
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}



