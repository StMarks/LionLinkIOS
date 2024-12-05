import SwiftUI
import Foundation

struct GroupResponse: Codable {
    let groups: [Groups]
}

struct Groups: Codable, Identifiable {
    let id: Int
    let name: String
    let photo: String?
    let events: [ClubEvents]?
    let members: [Members]?
    let announcements: [Announcement]?
    let type: String
    let season: String
}

struct ClubEvents: Codable, Identifiable {
    let id: Int
    let eventType: String
    let groupId: Int?
    let description: String
    let location: Location?
    let startTime: String
    let endTime: String
}


struct Members: Codable, Identifiable {
    
    var id: Int?
    let userId: Int // This must match the JSON key for the user ID
    let groupRole: String
    let user: Users
    
}

struct Users: Codable, Identifiable, Equatable {
    static func == (lhs: Users, rhs: Users) -> Bool {
        return false
    }
    
    var id: Int?
    let firstName: String
    let lastName: String
    let preferredName: String?
    let gradYear: Int
    let email: String
    let picture: String?
    let roleId: Int?
    let role: Roles?
}


struct Roles: Codable {
    let id: Int
    let name: String
    let permissions: [Permissions]
}

struct Permissions: Codable {
    let roleId: Int
    let permissionId: Int
    let permission: PermissionDetail
}

struct PermissionDetail: Codable {
    let id: Int
    let name: String
    let key: String
}

struct Announcement: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
    let authorId: Int
    let author: Author
    let groupId: Int?
    let postedAt: String
    
}

struct Author: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let preferredName: String?
    let gradYear: Int
    let email: String
    let picture: String?
    let roleId: Int?
    let role: Roles?
}



class GroupService {
    let baseURL = URL(string: "https://hub-dev.stmarksschool.org/v1/group")!
    let token: String
    
    init(token: String) {
        self.token = token
    }
    func postAnnouncement(groupId: Int, title: String, content: String, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("group/announcement/\(groupId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["title": title, "content": content]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Error posting announcement: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    completion(false, "Failed to post announcement, received status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, "Announcement posted successfully.")
            }
        }.resume()
    }

    func createEvent(groupId: Int, eventType: String, locationId: Int, startTime: String, endTime: String, description: String, completion: @escaping (Bool) -> Void) {
        let endpoint = baseURL.appendingPathComponent("event")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "groupId": groupId,
            "eventType": eventType,
            "locationId": locationId,
            "startTime": startTime,
            "endTime": endTime,
            "description": description
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error creating group event: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }

    func fetchGroupsById(_ id: Int, completion: @escaping (Groups?) -> Void) {
            let endpoint = baseURL.appendingPathComponent("\(id)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                            print("Error fetching club by ID: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                            return
                        }
                        if let data = data, let rawJSON = String(data: data, encoding: .utf8) {
                            print("Raw JSON data from fetchClubById: \(rawJSON)")
                        }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: Did not receive a valid HTTP response")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                guard let data = data else {
                    print("No data received from the server. HTTP Status Code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                if httpResponse.statusCode == 200 {
                    print("Data received: \(String(describing: String(data: data, encoding: .utf8)))")
                }
    
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
    
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let club = try JSONDecoder().decode(Groups.self, from: data)
                    DispatchQueue.main.async {
                        completion(club)
                    }
                } catch {
                    print("Error decoding club: \(error)")
                    let rawJSON = String(data: data, encoding: .utf8) ?? "Invalid data encoding"
                    print("Received JSON string: \(rawJSON)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    
    func fetchBatch(completion: @escaping ([Groups]?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error fetching clubs: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Did not receive a valid HTTP response")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("No data received from the server. HTTP Status Code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            if let responseDataString = String(data: data, encoding: .utf8) {
                    print("Response data as string: \(responseDataString)")
                }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let clubs = try decoder.decode([Groups].self, from: data)
                print("Fetched clubs successfully. HTTP Status Code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(clubs)
                }
            } catch {
                print("Error decoding clubs: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON string: \(jsonString)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchIndvBatch(completion: @escaping ([Groups]?) -> Void) {
        let endpoint = baseURL.appendingPathComponent("club")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching individual batches: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Error: Did not receive a valid HTTP response. Status code: \(httpResponse.statusCode)")
                } else {
                    print("Error: Did not receive a valid HTTP response.")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data else {
                print("No data received from the server.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            print("Raw response data: \(String(describing: String(data: data, encoding: .utf8)))")

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // Assuming the JSON structure matches the `Batch` struct
                let decodedResponse = try decoder.decode([Groups].self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                print("Error decoding individual batches: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    func joinClub(with clubId: Int, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("club/\(clubId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error joining club: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Failed to send request: \(error.localizedDescription)")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Did not receive a valid HTTP response")
                DispatchQueue.main.async {
                    completion(false, "Invalid response from the server.")
                }
                return
            }

            switch httpResponse.statusCode {
            case 200:
                print("Successfully joined the club.")
                DispatchQueue.main.async {
                    completion(true, "Successfully joined the club.")
                }
            case 400:
                print("Unable to join the club.")
                DispatchQueue.main.async {
                    completion(false, "Unable to join the club.")
                }
            case 500:
                print("Internal server error.")
                DispatchQueue.main.async {
                    completion(false, "Internal server error.")
                }
            default:
                print("Received unexpected status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(false, "Unexpected status code: \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
    }
    func leaveClub(with clubId: Int, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("club/\(clubId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error leaving club: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Failed to send request: \(error.localizedDescription)")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Did not receive a valid HTTP response")
                DispatchQueue.main.async {
                    completion(false, "Invalid response from the server.")
                }
                return
            }

            switch httpResponse.statusCode {
            case 200:
                print("Successfully left the club.")
                DispatchQueue.main.async {
                    completion(true, "Successfully left the club.")
                }
            case 400:
                print("Unable to leave the club.")
                DispatchQueue.main.async {
                    completion(false, "Unable to leave the club.")
                }
            case 500:
                print("Internal server error.")
                DispatchQueue.main.async {
                    completion(false, "Internal server error.")
                }
            default:
                print("Received unexpected status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(false, "Unexpected status code: \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
    }
}

