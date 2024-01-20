import SwiftUI

struct CreateEventView: View {
    @State private var description: String = ""
    @State private var selectedColor: Color = .blue
    @State private var location: String = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @Binding var needsRefresh: Bool
    @Environment(\.presentationMode) var presentationMode
    var token: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Description", text: $description)
                    ColorPicker("Choose Color", selection: $selectedColor, supportsOpacity: false)
                    TextField("Location", text: $location)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                }

                Button("Create Event") {
                    createEvent()
                }
            }
            .navigationBarTitle("Create Event", displayMode: .inline)
        }
    }

    func createEvent() {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        print(description)
        let eventDetails: [String: Any] = [
            "description": description,
            "color": selectedColor.toHexString(),
            "location": location,
            "startTime": dateFormatter.string(from: startTime),
            "endTime": dateFormatter.string(from: endTime)
        ]

        guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/student/schedule/manual") else {
            print("Invalid url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: eventDetails, options: [])
        } catch let error {
            print("Failed to serialize event details to JSON with error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Response status code: \(httpResponse.statusCode)")
                        if httpResponse.statusCode == 201 {
                            print("Successfully created event")
                            DispatchQueue.main.async {
                                self.needsRefresh = true
                            }
                        } else {
                            print("Failed to create event with status code: \(httpResponse.statusCode)")
                        }
                    }
                    // Move the refresh and dismissal out here so it executes regardless of response
                    self.needsRefresh = true
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.resume()
            }

}

extension Color {
    // Convert Color to hex string
    func toHexString() -> String {
        // Convert the Color to UIColor (extended in UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Convert to hex string
        let hexString = String(format: "#%02lX%02lX%02lX",
                               lroundf(Float(red * 255)),
                               lroundf(Float(green * 255)),
                               lroundf(Float(blue * 255)))
        return hexString
    }
}
