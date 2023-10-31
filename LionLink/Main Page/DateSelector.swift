import SwiftUI

// A view to display a week (Sunday to Saturday) with the centered day highlighted.
struct DateSelector: View {
    @Binding var centeredDate: Date
    let dateFormatter: DateFormatter

    var body: some View {
        HStack(spacing: 12) {
            // Arrow button to move the centered date backward by one day.
            Button(action: {
                centeredDate = Calendar.current.date(byAdding: .day, value: -1, to: centeredDate)!
            }) {
                Image(systemName: "arrow.left")
            }

            Spacer()

            // Display the dates for the current week.
            ForEach(0..<7) { offset in
                let weekDate = dateForDayOfWeek(offset: offset)
                Text(dateFormatter.string(from: weekDate))
                    .frame(width: 30, height: 30)
                    .background(isCenteredDate(date: weekDate) ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .foregroundColor(isCenteredDate(date: weekDate) ? .white : .black)
                    .font(.headline)
            }

            Spacer()

            // Arrow button to move the centered date forward by one day.
            Button(action: {
                centeredDate = Calendar.current.date(byAdding: .day, value: 1, to: centeredDate)!
            }) {
                Image(systemName: "arrow.right")
            }
        }
        .padding()
    }

    // Helper function to determine if a date is the centered date.
    private func isCenteredDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: centeredDate)
    }

    // Helper function to get the date for a specific day of the week based on the centeredDate.
    private func dateForDayOfWeek(offset: Int) -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: centeredDate))!
        return calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
    }
}
