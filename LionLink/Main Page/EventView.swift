import SwiftUI

struct EventView: View {
    let event: Event
    let hourHeight: CGFloat

    var body: some View {
        let startHour = CGFloat(Calendar.current.component(.hour, from: event.start))
        let startMinute = CGFloat(Calendar.current.component(.minute, from: event.start))
        
        let durationInSeconds = event.end.timeIntervalSince(event.start)
        let durationInHours = durationInSeconds / 3600
        let height = CGFloat(durationInHours) * hourHeight

        return VStack {
            Text("\(formatTime(event.start)) - \(formatTime(event.end))")
            Text(event.name)
        }
        .padding()
        .frame(height: height)
        .background(event.color)
        .cornerRadius(8)
        .offset(y: (startMinute / 60) * hourHeight)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

//hello
