//
import SwiftUI

struct DayView: View {
    let hours: [Int] = Array(0..<24)
    let events: [Event]

    var body: some View {
        ScrollView {
//            VStack(spacing: 0) {
//                ForEach(hours, id: \.self) { hour in
//                    HStack {
//                        Text("\(hour):00")
//                            .frame(width: 50, alignment: .leading)
//                            .padding(.leading)
//                        
//                        ZStack(alignment: .topLeading) {
//                            Divider()
//                                .background(Color.gray)
//                                .frame(height: 60)
//
//                            ForEach(events.filter { isEvent($0, happeningDuring: hour) }, id: \.id) { event in
//                                GeometryReader { geo in
//                                    EventView(event: event)
//                                        .frame(width: geo.size.width, height: eventHeight(for: event))
//                                        .offset(y: eventOffset(for: event))
//                                }
//                            }
//                        }.frame(maxHeight: .infinity)
//                        
//                        Spacer()
//                    }
//                }
//            }
        }
    }
    
    func yOffset(for event: Event) -> CGFloat {
        let startHour = Calendar.current.component(.hour, from: event.start)
        let startMinute = Calendar.current.component(.minute, from: event.start)
        
        return CGFloat(startHour * 60 + startMinute - 8 * 60) // Assuming 8:00 is the first hour in the calendar.
    }
    func eventOffset(for event: Event) -> CGFloat {
        let startHour = Calendar.current.component(.hour, from: event.start)
        let startMinute = Calendar.current.component(.minute, from: event.start)
        return CGFloat(startHour - 7) * 60 + CGFloat(startMinute)
    }


    func eventHeight(for event: Event) -> CGFloat {
        let duration = event.end.timeIntervalSince(event.start) / 60.0 // in minutes
        return CGFloat(duration) // Given that each minute is 1 point
    }
    
    func isEvent(_ event: Event, happeningDuring hour: Int) -> Bool {
        let startHour = Calendar.current.component(.hour, from: event.start)
        return startHour == hour
    }

}


