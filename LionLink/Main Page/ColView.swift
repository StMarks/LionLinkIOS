import SwiftUI

struct ColView: View {
    var events: [Event]
    private let hourHeight: CGFloat = 60
    @Binding var selectedEvent: Event?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<24) { hour in
                    HStack {
                        Text("\(hour % 12 == 0 ? 12 : hour % 12) \(hour < 12 ? "AM" : "PM")")
                            .frame(width: 50)
                        Divider()
                            .frame(height: hourHeight)
                    }
                }
                ForEach(events) { event in
                    EventViewCol(event: event, hourHeight: hourHeight, selectedEvent: $selectedEvent)
                        .frame(height: eventHeight(event: event))
                        .offset(y: eventOffset(event: event))
                }
            }
            CurrentTimeIndicator(hourHeight: hourHeight)
                .frame(height: CGFloat(24) * hourHeight, alignment: .top)
        }
    }

    func eventHeight(event: Event) -> CGFloat {
        let duration = event.endTime.timeIntervalSince(event.startTime)
        return max(CGFloat(duration / 3600) * hourHeight, hourHeight)
    }

    func eventOffset(event: Event) -> CGFloat {
        let startOfDay = Calendar.current.startOfDay(for: event.startTime)
        return CGFloat(event.startTime.timeIntervalSince(startOfDay) / 3600) * hourHeight
    }
}

struct EventViewCol: View {
    var event: Event
    var hourHeight: CGFloat
    @Binding var selectedEvent: Event?
    
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(Color(hex: event.colorHex))
                .frame(width: 4)
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text("\(event.startTime.formatted()), \(event.endTime.formatted())")
                    .font(.subheadline)
                Text(event.location)
                    .font(.subheadline)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.top, 1)
        .onTapGesture {
            self.selectedEvent = event
        }
    }
}

struct CurrentTimeIndicator: View {
    var hourHeight: CGFloat
    var body: some View {
        GeometryReader { geometry in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let secondsFromStartOfDay = now.timeIntervalSince(startOfDay)
            let yPosition = CGFloat(secondsFromStartOfDay / 3600) * hourHeight

            Rectangle()
                .frame(width: geometry.size.width, height: 1)
                .foregroundColor(.red)
                .offset(y: yPosition)
        }
    }
}

//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        _ = scanner.scanString("#")
//
//        var rgb: UInt64 = 0
//        scanner.scanHexInt64(&rgb)
//
//        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
//        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
//        let b = Double(rgb & 0x0000FF) / 255.0
//
//        self.init(red: r, green: g, blue: b)
//    }
//}
