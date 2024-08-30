import SwiftUI

struct EventView: View {
    var event: Event
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
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
    }
        
}
