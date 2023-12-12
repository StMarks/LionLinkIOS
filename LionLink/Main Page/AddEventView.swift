import SwiftUI
import UIKit

struct AddEventView: View {
    @AppStorage("token") var token: String?
    @Binding var events: [Event]
    @State private var title: String = ""
    @State private var teacher: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var location: String = ""
    @State private var selectedColor: Color = .gray
    @Environment(\.dismiss) var dismiss
    
    func postEventToBackend(event: Event) {
        func postEventToBackend(event: Event) {
            guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/student/schedule/manual") else { return }
            var request = URLRequest(url: url)
            if(token == nil) {
                // ruh roh
                return
            }
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body: [String: Any] = [
                "description": event.title,
                "color": event.colorHex,
                "location": event.location,
                "startTime": event.startDateTime,
                "endTime": event.endDateTime
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    // Handle the error appropriately
                    print("Error posting event: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    // Handle the success response
                    print("Event created successfully")
                } else {
                    // Handle server error or non-success response
                    print("Error creating event: \(response)")
                }
            }.resume()
        }
    }
        func hexStringFromColor(color: Color) -> String {
            // Convert Color to UIColor
            let uiColor = UIColor(color)
            
            // Extract RGBA components
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            // Convert to Hex String
            let hexString = String(format: "#%02lX%02lX%02lX",
                                   lroundf(Float(red * 255)),
                                   lroundf(Float(green * 255)),
                                   lroundf(Float(blue * 255)))
            return hexString
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    
                    if !title.isEmpty || !location.isEmpty {
                        EventView(event: Event(startTime: startTime.timeString, endTime: endTime.timeString, teacher: teacher, title: title, abbreviatedTitle: "", location: location, colorHex: hexStringFromColor(color: selectedColor)))
                    }
                    
                    Form {
                        Section(header: Text("EVENT DETAILS")) {
                            CustomTextField(placeholder: "Title", text: $title)
                            CustomTextField(placeholder: "Teacher", text: $teacher)
                            CustomTextField(placeholder: "Location", text: $location)
                            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                            ColorPicker("Choose a color", selection: $selectedColor, supportsOpacity: false)
                        }
                        
                        Button("Create") {
                            let newEvent = Event(startTime: startTime.timeString, endTime: endTime.timeString, teacher: teacher, title: title, abbreviatedTitle: "", location: location, colorHex: hexStringFromColor(color: selectedColor))
                            
                            postEventToBackend(event: newEvent)
                            events.append(newEvent)
                            dismiss()
                            
                        }
                        .disabled(title.isEmpty || location.isEmpty || endTime <= startTime)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(selectedColor))
                        .foregroundColor(.white)
                    }
                }
                .navigationTitle("Add Event")
                .navigationBarItems(leading: Button("Cancel") {
                    dismiss()
                })
            }
        }
    
    
}
