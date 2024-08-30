import SwiftUI

struct EventRow: View {
    let event: ClubEvents

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formatTime(event.startTime) + " - " + formatTime(event.endTime)).font(.headline)
                Text(event.description).font(.subheadline)
            }
            Spacer()
            Text(event.location!.buildingName).font(.subheadline).padding(.trailing)
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private func formatTime(_ timeString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.timeZone = TimeZone(identifier: "US/Eastern")

        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        } else {
            return timeString
        }
    }
}
