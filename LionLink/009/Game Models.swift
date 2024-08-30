struct GameDetails: Codable {
    let id: Int
    let userId: Int
    let playing: Bool
    let userClickedTargetElim: Bool
    let userElimByOther: Bool
    let currentTargetId: Int?
    let eliminations: [TagElimination]
    let user: Usert
    let target: Target?
    let starting: Int
    let remaining: Int
}

struct TagElimination: Codable{
    let id: Int
    let taggerId: Int
    let target: Target?
    let taggedUserId: Int
    let time: String
}

struct Target: Codable {
    let firstName: String
    let nickName: String
    let lastName: String
    let picture: String?
    let grade: Int
}

struct Player: Codable {
    let id: Int
    let userId: Int
    let playing: Bool
    let userClickedTargetElim: Bool
    let userElimByOther: Bool
    let currentTargetId: Int?
    let eliminations: [TagElimination]?
    let user: Usert
    let target: Target?
}

struct Usert: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let nickName: String
    let gradYear: Int
    let email: String
    let googleId: String
    let roleId: Int
    let picture: String?
}
