import SwiftUI

struct EventView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(event.title)
                .font(.headline)
                .foregroundColor(.white)
            Text("Teacher: \(event.teacher!)")
                .font(.subheadline)
                .foregroundColor(.white)
//            Text("Time: \(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))")
//                .font(.caption)
//                .foregroundColor(.white)
            Text("Location: \(event.location)")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(event.color)
        .cornerRadius(10)
    }
}
