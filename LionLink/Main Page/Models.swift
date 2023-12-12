import Foundation

struct User: Codable, Identifiable {
    var id: String { email }
    let firstName: String
    let lastName: String
    let preferredName: String
    let gradYear: Int
    let email: String
}

struct ScheduleItem: Codable, Identifiable, Hashable {
    let id: UUID = UUID()
    let startTime: Date
    let endTime: Date
    let teacher: String
    let title: String
    let abbreviatedTitle: String
    let location: String
    let color: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  
    }
}

struct ScheduleResponse: Codable {
    let scheduleDayLimit: Int?
    let user: User
    let schedule: [ScheduleItem]
}
