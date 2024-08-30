import SwiftUI

struct DayScheduleView: View {
    // Array of events to display.
    var events: [[Event]]
    @AppStorage("token") var token: String?

    @Binding var isPanelShown: Bool
    var togglePanel: () -> Void
    @Binding var selectedEventName: String?
    
    @AppStorage("isDarkMode") public var isDarkMode: Bool?
    @AppStorage("tokenClear") public var tokenClear: Bool?
    
    
    @State private var selectedIndex: Int = 0
    
    
    
    
    
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

    
    func printEv(){
        print(events)
    }
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

    // Main body of the DayScheduleView.
    var body: some View {
        DateSelectorView(selectedDayIndex: $selectedIndex)
      
        VStack{
        
            
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
                            printEv()
                            return formatter.string(from: currentDate)
                        }
                        
            
                    
                        
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: UIScreen.main.bounds.width-30, height: 2)
                            .position(x: UIScreen.main.bounds.width / 2, y: positionYFor(time: currentTime))
                            .id("redLine") // We're tagging this view so that we can scroll to it
                    }
                    .frame(height: hourHeight * CGFloat(hoursInDay))
                
                    .onAppear {
                        // Scroll to the red line's position when the view first appears
                        reader.scrollTo("redLine", anchor: .center)
                    }
                }
            }
        }
    }
}

