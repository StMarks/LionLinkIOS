
import SwiftUI

struct DayView: View {
    let daySchedule: [ScheduleItem]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(daySchedule) { item in
                    EventView(scheduleItem: item)
                }
            }
        }
        .navigationTitle(dayTitle)
    }

    private var dayTitle: String {

        // Check if there is a first item in the daySchedule array
        if let firstEvent = daySchedule.first {
            // If there is, format the startTime of the first event for the title
            return "Events for \(dayFormatter.string(from: firstEvent.startTime))"
        } else {
            // If there isn't, provide a default title
            return "No Events"
        }
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full // Adjust the style as needed
        formatter.timeStyle = .none
        return formatter
    }
}
