import SwiftUI

struct EventCreationView: View {
    var eventAdded: (Event) -> Void

    @State private var title: String = ""
    @State private var startTime: String = ""
    @State private var endTime: String = ""
    @State private var teacher: String = ""
    @State private var location: String = ""
    @State private var color: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Start Time (e.g., 09:00)", text: $startTime)
                TextField("End Time (e.g., 10:00)", text: $endTime)
                TextField("Teacher", text: $teacher)
                TextField("Location", text: $location)
                TextField("Color (e.g., red)", text: $color)

                Button("Save") {
                    let newEvent = Event(
                        id: Int.random(in: 1...1000), // Random ID, modify as needed
                        startTime: startTime,
                        endTime: endTime,
                        teacher: teacher,
                        title: title,
                        location: location,
                        coler: color
                    )
                    eventAdded(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("New Event", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
