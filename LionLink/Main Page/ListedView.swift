import SwiftUI

struct ListedView: View {
    var events: [Event]
    let hourHeight: CGFloat = 60 // Height of one hour in the view
    @Binding var selectedEvent: Event?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(0..<24) { hour in
                    HourMarker(hour: hour, hourHeight: hourHeight)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .background(
                GeometryReader { geometry in
                    ZStack(alignment: .topLeading) {
                        ForEach(events) { event in
                            EventViews(selectedEvent: $selectedEvent, event: event, totalHeight: geometry.size.height, hourHeight: hourHeight)
                        }
                        CurrentTimeIndicatorView(totalHeight: geometry.size.height, hourHeight: hourHeight)
                    }
                }
            )
        }
    }
}

struct HourMarker: View {
    let hour: Int
    let hourHeight: CGFloat

    var body: some View {
        Text("\(hour == 0 || hour == 12 ? 12 : hour % 12) \(hour < 12 ? "AM" : "PM")")
            .frame(height: hourHeight, alignment: .topLeading)
            .padding(.leading, 5)
    }
}

struct EventViews: View {
    @Binding var selectedEvent: Event?
    var event: Event
        let totalHeight: CGFloat
        let hourHeight: CGFloat
        let minimumHeightToShowDetails: CGFloat = 50 // Minimum height to show details

        var body: some View {
            let topOffset = calculateOffset(for: event, in: totalHeight)
            let eventHeight = calculateHeight(for: event, in: totalHeight)
            let showDetails = eventHeight > minimumHeightToShowDetails

            return VStack {
                HStack {
                    Rectangle()
                        .fill(Color(hex: event.colorHex))
                        .frame(width: 7)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .lineLimit(1)

                        if showDetails {
                            Text("\(event.startTime, formatter: dateFormatter) - \(event.endTime, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)

                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(Color(hex: event.colorHex))
                                Text(event.location)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)

                    Spacer()
                }
                .frame(height: eventHeight)
//                .background(Color(hex: event.colorHex).opacity(0.3))
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                .onTapGesture {
                    self.selectedEvent = event
                }
            }
            .offset(x: 50, y: topOffset) // Ensure this aligns with the hour markers
            .frame(maxWidth: .infinity, maxHeight: eventHeight)
        }

        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }()

    func calculateHeight(for event: Event, in totalHeight: CGFloat) -> CGFloat {
        let duration = event.endTime.timeIntervalSince(event.startTime)
        return (duration / 3600) * hourHeight
    }

    func calculateOffset(for event: Event, in totalHeight: CGFloat) -> CGFloat {
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: event.startTime)
        let startMinute = calendar.component(.minute, from: event.startTime)
        return (CGFloat(startHour) * hourHeight) + (CGFloat(startMinute) / 60 * hourHeight)
    }
}

struct CurrentTimeIndicatorView: View {
    let totalHeight: CGFloat
    let hourHeight: CGFloat
    @State private var currentTimeOffset: CGFloat = 0

    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height: 2)
            .foregroundColor(.red)
            .offset(y: currentTimeOffset)
            .onAppear {
                setCurrentTimeOffset()
                // Update the position of the indicator every minute
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    setCurrentTimeOffset()
                }
            }
    }
    
    private func setCurrentTimeOffset() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let secondsSinceStartOfDay = now.timeIntervalSince(startOfDay)
        currentTimeOffset = (secondsSinceStartOfDay / 3600) * hourHeight
    }
}
