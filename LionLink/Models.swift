import Foundation


// MARK: - Group Models
struct Batch: Codable, Identifiable {
    var id: Int?
    var name: String
    var type: String
    var season: String
    var members: [Member]?
    var batchEvents: [BatchEvent]?
    var photoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, type, season, members
        case batchEvents = "events"
        case photoUrl = "photo"
    }
}

struct BatchEvent: Codable {
    var eventType: String
    var startTime: String
    var endTime: String
    var description: String?
    var location: String?
}

struct Member: Codable, Identifiable {
    let id: Int?
    var groupRole: String
    var userId: Int
    var user: User
}

struct User: Codable {
    var firstName: String
    var nickName: String
    var lastName: String
    var email: String
    var gradYear: Int
    
}

//MARK: - Location Models

struct Location: Codable, Identifiable {
    var id: Int?
    var buildingName: String
    var roomName: String
    
    init(buildingName: String, roomName: String) {
        self.buildingName = buildingName
        self.roomName = roomName
    }
}

//MARK: - Club Models
