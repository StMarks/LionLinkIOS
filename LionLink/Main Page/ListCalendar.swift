import SwiftUI

struct ListCalendar: View {
    @State private var events: [[Event]] = Array(repeating: [], count: 7) // 7 days in a week
    @State private var selectedDayIndex: Int = Calendar.current.component(.weekday, from: Date()) - 1 // 0-based index
    @State private var showingAddEventView = false
    let daysOfWeek = Calendar.current.shortWeekdaySymbols

    var body: some View {
        NavigationView {
            VStack {
                            Text(dateString(for: Date()))
                                .font(.title)
                                .padding()

                            WeekdaysView(selectedDayIndex: $selectedDayIndex, days: daysOfWeek)

                            ScrollView {
                                ForEach(events[selectedDayIndex]) { event in
                                    EventView(event: event)
                                }
                                .onDelete(perform: deleteEvent)
                            }
                        }
                        .navigationBarItems(trailing: Button(action: {
                            showingAddEventView = true
                        }) {
                            Image(systemName: "plus")
                        })
//            .sheet(isPresented: $showingAddEventView) {
//                AddEventView(events: $events, dayIndex: selectedDayIndex)
//            }
        }
    }

    func dateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }

    func deleteEvent(at offsets: IndexSet) {
        events[selectedDayIndex].remove(atOffsets: offsets)
    }
}

struct WeekdaysView: View {
    @Binding var selectedDayIndex: Int
    let days: [String]

    var body: some View {
        HStack {
            ForEach(days.indices, id: \.self) { index in
                Button(action: {
                    self.selectedDayIndex = index
                }) {
                    Text(days[index])
                        .foregroundColor(selectedDayIndex == index ? .white : .gray)
                        .frame(width: 45, height: 45)
                        .background(selectedDayIndex == index ? Color.blue : Color.clear)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
    }
}
