import SwiftUI

struct DateSelectorView: View {
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @Binding var selectedDayIndex: Int // Use Binding to allow ContentView to track changes
    let dates: [String]

    // Compute the dates within the initializer
    init(selectedDayIndex: Binding<Int>) {
        self._selectedDayIndex = selectedDayIndex
        let today = Date()
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: today)
        let daysOffset = currentWeekday - calendar.firstWeekday
        let monday = calendar.date(byAdding: .day, value: -daysOffset, to: today)!
        
        self.dates = (0..<7).map { offset in
            let weekdayDate = calendar.date(byAdding: .day, value: offset, to: monday)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            return formatter.string(from: weekdayDate)
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) { // Adjust spacing between the date boxes
                ForEach(Array(zip(weekDays.indices, weekDays)), id: \.0) { index, day in
                    Button(action: {
                        self.selectedDayIndex = index
                    }) {
                        VStack {
                            Text(day)
                                .font(.headline)
                            Text(dates[index])
                                .font(.subheadline)
                        }
                        .frame(width: 60, height: 60) // Adjusted width of the boxes
                        .padding(.vertical, 10)
                        .background(self.selectedDayIndex == index ? Color.blue : Color.clear)
                        .foregroundColor(self.selectedDayIndex == index ? Color.white : Color.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
