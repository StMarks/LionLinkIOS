import SwiftUI

struct DayEventView: View {
    @Binding var selectedIndex: Int
    @Binding var showingCreateEventView: Bool
    
    let eventsByDay: [[Event]]
    
    
    @AppStorage("token") var token: String?
    @State private var isCalendarViewActive = false // This will toggle between the list and calendar view
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            VStack {
                // Toggle Button
                Toggle(isOn: $isCalendarViewActive) {
                    Image(systemName: isCalendarViewActive ? "calendar" : "rectangle.grid.1x2")
                }
                .padding()
                
                
                // Check if the events array for the selected index is empty
                if eventsByDay.indices.contains(selectedIndex) && !eventsByDay[selectedIndex].isEmpty {
                    if isCalendarViewActive {
                        // Calendar-style view
                        ZStack(alignment: .bottomTrailing) {
                            
                            ColView(events: eventsByDay[selectedIndex])
                        }
                    } else {
                        ZStack(alignment: .bottomTrailing) {
                            ListView(events: eventsByDay[selectedIndex])
                        }
                    }
                } else {
                    // Display a message if there are no events
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView{
                            Text("No events currently")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
            }
            Button(action: {
                showingCreateEventView=true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
            }
        }
    }
}

