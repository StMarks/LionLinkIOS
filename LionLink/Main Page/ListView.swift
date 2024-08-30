import SwiftUI

struct ListView: View {
    let events: [Event]
    @Binding var selectedEvent: Event?
    var onDelete: (Event) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        if colorScheme == .dark {
            ScrollView {
                VStack(spacing: 16) { // Space between event cards
                    ForEach(events.sorted(by: { $0.startTime < $1.startTime })) { event in
                        // Time label above each event card
                        Text("\(dateFormatter.string(from: event.startTime)) - \(dateFormatter.string(from: event.endTime))")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // Event card
                        HStack {
                            Rectangle()
                                .fill(Color(hex: event.colorHex))
                                .frame(width: 7)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(event.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("\(dateFormatter.string(from: event.startTime)) - \(dateFormatter.string(from: event.endTime))")
                                                                .font(.subheadline)
                                                                .foregroundColor(.white)

                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(Color(hex: event.colorHex))
                                    Text(event.location)
                                        .font(.subheadline)
                                }
                                .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)

                            Spacer()
                        }
                        .frame(height: 100)
                        .background(Color(hex: "171616"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            self.selectedEvent = event
                        }
                    }
                }
                .padding(.top, 10)
            }
        }else{
            ScrollView {
                VStack(spacing: 16) { // Space between event cards
                    ForEach(events.sorted(by: { $0.startTime < $1.startTime })) { event in
                        // Time label above each event card

                        Text("\(dateFormatter.string(from: event.startTime)) - \(dateFormatter.string(from: event.endTime))")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // Event card
                        HStack {
                            Rectangle()
                                .fill(Color(hex: event.colorHex))
                                .frame(width: 4)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(event.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Text("\(dateFormatter.string(from: event.startTime)) - \(dateFormatter.string(from: event.endTime))")
                                                                .font(.subheadline)
                                                                .foregroundColor(.gray)

                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(Color(hex: event.colorHex))
                                    Text(event.location)
                                        .font(.subheadline)
                                }
                                .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)

                            Spacer()
                        }
                        .frame(height: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            self.selectedEvent = event
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}




