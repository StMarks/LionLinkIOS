import SwiftUI

struct Account: Codable, Equatable, Identifiable {
    enum CodingKeys: CodingKey {
        case firstName
        case lastName
        case preferredName
        case gradYear
        case email
    }
    
    var id = UUID()
    let firstName: String
    let lastName: String
    let preferredName: String
    let gradYear: String
    let email: String
    
   
}
