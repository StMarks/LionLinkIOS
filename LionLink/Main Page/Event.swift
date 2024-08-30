import SwiftUI

struct Event: Encodable, Identifiable, Equatable {
    var id = UUID()
    let indvId: Int?
    let startTime: Date
    let endTime: Date
    let teacher: String?
    let title: String
    let abbreviatedTitle: String?
    let location: String
    let colorHex: String
   
    
    
    init(indvId: Int? = nil, startTime: String, endTime: String, teacher: String? = nil, title: String, abbreviatedTitle: String? = nil, location: String, hex: String) {
            if let startDate = Date.iso8601Formatter.date(from: startTime) {
                self.startTime = startDate.addingTimeInterval(4 * 60 * 60) // Add 5 hours
            } else {
                self.startTime = Date()
            }
            
            if let endDate = Date.iso8601Formatter.date(from: endTime) {
                self.endTime = endDate.addingTimeInterval(4 * 60 * 60) // Add 5 hours
            } else {
                self.endTime = Date()
            }
            
            self.teacher = teacher
            self.title = title
            self.abbreviatedTitle = abbreviatedTitle
            self.location = location
            self.colorHex = hex
            self.indvId = indvId
        }

       
    func hexStringFromColor(color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)

        let hexString = String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        return hexString
    }
}

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
