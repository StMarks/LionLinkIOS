import SwiftUI

struct ColView: View {
    
    var events: [Event]
    @State private var selectedEventId: UUID?
    private let hourHeight: CGFloat = 60 // Height for one hour slot

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                ZStack(alignment: .topLeading) {
                    timeMarkings
                    VStack(spacing: 0) {
                        ForEach(events) { event in
                            EventCard(event: event, width: geometry.size.width - 60)
                                .frame(height: eventHeight(event: event))
                                .offset(x: 60, y: eventOffset(event: event)) // Offset by the width of the time labels
                                .onTapGesture {
                                    selectedEventId = event.id
                                }
                        }
                    }
                    .frame(width: geometry.size.width, alignment: .topLeading)
                }
                .overlay(
                    CurrentTimeIndicator(hourHeight: hourHeight),
                    alignment: .topLeading
                )
            }
            .frame(height: geometry.size.height)
        }
    }

    private var timeMarkings: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<24, id: \.self) { hour in
                Text("\(hour == 0 || hour == 12 ? 12 : hour % 12) \(hour < 12 ? "AM" : "PM")")
                    .frame(width: 50, height: hourHeight)
            }
        }
    }
    
    private func eventHeight(event: Event) -> CGFloat {
        let duration = event.endTime.timeIntervalSince(event.startTime)
        return CGFloat(duration / 3600) * hourHeight
    }
    
    private func eventOffset(event: Event) -> CGFloat {
        let startOfDay = Calendar.current.startOfDay(for: event.startTime)
        let offset = event.startTime.timeIntervalSince(startOfDay)
        return CGFloat(offset / 3600) * hourHeight
    }
}

struct EventCard: View {
    var event: Event
    var width: CGFloat
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(hex: event.colorHex))
                .frame(width: 4)
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.headline)
                Text("\(timeFormatter.string(from: event.startTime)) - \(timeFormatter.string(from: event.endTime))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "location.fill")
                    Text(event.location)
                        .font(.subheadline)
                }
                .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            Spacer()
        }
        .frame(width: width, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal, 8)
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

struct CurrentTimeIndicator: View {
    let hourHeight: CGFloat
    var body: some View {
        GeometryReader { geometry in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let secondsFromStartOfDay = now.timeIntervalSince(startOfDay)
            let yPosition = CGFloat(secondsFromStartOfDay / 3600) * hourHeight
            
            Rectangle()
                .frame(width: geometry.size.width - 60, height: 1) // Subtract the width of the time labels
                .foregroundColor(.red)
                .offset(x: 60, y: yPosition) // Offset by the width of the time labels
                .animation(.linear, value: yPosition)
        }
    }
}
