import SwiftUI




// MARK: - Networking Service

class BatchService {
    let baseURL = URL(string: "https://hub-dev.stmarksschool.org/v1/group")!
    let token: String
        
    init(token: String) {
        self.token = token
    }
    
    func deleteEvent(eventId: Int, completion: @escaping (Bool, String) -> Void) {
//        let endpoint = baseURL.appendingPathComponent("/event")
        let endpoint = URL(string: "https://hub-dev.stmarksschool.org/v1/group/event")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "eventId": eventId,]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, "Error editing event: \(error!.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Error: Did not receive a valid HTTP response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true, "Event deleted successfully")
            } else {
                completion(false, "Failed to delete event with status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
    func editEvent(eventId: Int, groupId: Int, eventType: String, locationId: Int, startTime: String, endTime: String, description: String, completion: @escaping (Bool, String) -> Void) {
//        let endpoint = baseURL.appendingPathComponent("/event")
        let endpoint = URL(string: "https://hub-dev.stmarksschool.org/v1/group/event")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "eventId": eventId,
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
                completion(false, "Error editing event: \(error!.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Error: Did not receive a valid HTTP response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true, "Event edited successfully")
            } else {
                completion(false, "Failed to edit event with status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }

    
    func editAnnouncement(announcementId: Int, title: String, content: String, completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("announcement/\(announcementId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["title": title, "content": content]
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Error: Did not receive a valid HTTP response")
                    return
                }
                
                if let error = error {
                    completion(false, "Error editing announcement: \(error.localizedDescription)")
                } else if httpResponse.statusCode == 200 {
                    completion(true, "Announcement edited successfully")
                } else {
                    completion(false, "Failed to edit announcement with status code: \(httpResponse.statusCode)")
                }
            }.resume()
    }
    func updateUserRole(groupId: Int, userId: Int, newRole: String, completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("group/role/\(groupId)/\(userId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["roleName": newRole]
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(false, "Error updating user role: \(error!.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true, "User role updated successfully.")
                } else if let httpResponse = response as? HTTPURLResponse {
                    completion(false, "Failed to update user role with status code: \(httpResponse.statusCode)")
                } else {
                    completion(false, "Invalid response from the server.")
                }
            }.resume()
        }

    
    func createGroupEvent(groupId: Int, eventType: String, locationId: Int, startTime: String, endTime: String, description: String, completion: @escaping (Bool) -> Void) {
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
    
    func fetchBatch(completion: @escaping ([Batch]?) -> Void) {
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

            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let clubs = try decoder.decode([Batch].self, from: data)
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

    func fetchIndvBatch(completion: @escaping ([Batch]?) -> Void) {
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
                let decodedResponse = try decoder.decode([Batch].self, from: data)
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

    
        func createClub(club: Batch, completion: @escaping (Bool) -> Void) {
            guard let jsonData = try? JSONEncoder().encode(club) else {
                print("Error encoding club data.")
                completion(false)
                return
            }
            
            var request = URLRequest(url: baseURL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")  
                request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error posting club: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: Did not receive a valid HTTP response")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }

                if httpResponse.statusCode == 201 {
                    print("Club created successfully. HTTP Status Code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("Failed to create club with status code: \(httpResponse.statusCode)")
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("Server response body: \(responseBody)")
                    }
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
            task.resume()
        }
    func deleteAnnouncement(announcementId: Int, completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("announcement/\(announcementId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "DELETE"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { _, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Error: Did not receive a valid HTTP response")
                    return
                }

                if let error = error {
                    completion(false, "Error deleting announcement: \(error.localizedDescription)")
                } else if httpResponse.statusCode == 200 {
                    completion(true, "Announcement deleted successfully")
                } else {
                    completion(false, "Failed to delete announcement with status code: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    func postGroupEvent(groupId: Int, eventType: String, locationId: Int, startTime: String, endTime: String, description: String, completion: @escaping (Bool, String) -> Void) {
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
                    completion(false, "Error posting event: \(error!.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Error: Did not receive a valid HTTP response")
                    return
                }
                
                if httpResponse.statusCode == 201 {
                    completion(true, "Event posted successfully")
                } else {
                    completion(false, "Failed to post event with status code: \(httpResponse.statusCode)")
                }
            }.resume()
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

extension BatchService {
    func updateGroupPhoto(groupId: Int, photoData: Data, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("image/\(groupId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading photo: \(error)")
                completion(false, "Error uploading photo: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, "Photo uploaded successfully")
                } else {
                    completion(false, "Server error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    func fetchBatchById(_ id: Int, completion: @escaping (Batch?) -> Void) {
        print("testing")
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
                let club = try JSONDecoder().decode(Batch.self, from: data)
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

    func postAnnouncement(groupId: Int, title: String, content: String, completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("announcement/\(groupId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["title": title, "content": content]
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Error: Did not receive a valid HTTP response")
                    return
                }
                if let error = error {
                    completion(false, "Error posting announcement: \(error.localizedDescription)")
                } else if httpResponse.statusCode == 201 {
                    completion(true, "Announcement posted successfully")
                } else {
                    completion(false, "Failed to post announcement with status code: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    
    func deleteBatchById(_ id: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = baseURL.appendingPathComponent("\(id)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

        }
        task.resume()
    }
}

// MARK: - SwiftUI Views
struct BatchDetailView: View {
    @State private var batch: Batch?
    @State private var inputBatchId: String = ""
    var batchService: BatchService
    
    var body: some View {
        VStack {
            TextField("Enter Batch ID", text: $inputBatchId)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Fetch Batch Details") {
                if let batchId = Int(inputBatchId) {
                    batchService.fetchBatchById(batchId) { fetchedBatch in
                        self.batch = fetchedBatch
                    }
                }
            }
            .padding()

            ScrollView {
                VStack(alignment: .leading) {
                    if let batch = batch {
                        Text("ID: \(batch.id ?? 0)").padding()
                        Text("Name: \(batch.name)").padding()
                        Text("Type: \(batch.type)").padding()
                        Text("Season: \(batch.season)").padding()
                        ForEach(batch.members ?? [], id: \.user.email) { member in
                            VStack(alignment: .leading) {
                                Text("Member Name: \(member.user.firstName) \(member.user.lastName)").padding(.leading, 20)
                                Text("Nick Name: \(member.user.nickName)").padding(.leading, 20)
                                Text("Email: \(member.user.email)").padding(.leading, 20)
                                Text("Role: \(member.groupRole)").padding(.leading, 20)
                                Text("Grad Year: \(member.user.gradYear)").padding(.leading, 20)
                                Text("------------------------").padding(.leading, 20)
                            }
                        }
                        Text("Events:").font(.headline).padding(.top, 10)
                        ForEach(batch.batchEvents ?? [], id: \.startTime) { event in
                            VStack(alignment: .leading) {
                                Text("Event Type: \(event.eventType)").padding(.leading, 20)
                                Text("Start Time: \(event.startTime)").padding(.leading, 20)
                                Text("End Time: \(event.endTime)").padding(.leading, 20)
                                Text("Description: \(event.description ?? "N/A")").padding(.leading, 20)
                                Text("Location: \(event.location ?? "N/A")").padding(.leading, 20)
                                Text("------------------------").padding(.leading, 20)
                            }
                        }
                    } else {
                        Text("Batch details will appear here.").padding()
                    }
                    
                    if let photoUrl = batch?.photoUrl, let imageUrl = URL(string: photoUrl) {
                                AsyncImage(url: imageUrl) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            }
                }
            }
        }
    }
}






struct BatchDeleteView: View {
    @State private var inputClubId: String = ""
    @State private var deleteStatus: String = "Enter an ID and press 'Delete Club'"
    var clubService: BatchService
    var body: some View {
        VStack {
            TextField("Enter Club ID", text: $inputClubId)
                .keyboardType(.numberPad)
                .padding()
            Button("Delete Club") {
                if let clubId = Int(inputClubId) {
                    clubService.deleteBatchById(clubId) { success in
                        deleteStatus = success ? "Club deleted successfully" : "Failed to delete club"
                    }
                }
            }
            Text(deleteStatus)
        }
    }
}

struct PostAnnouncementView: View {
    @State private var groupIdInput: String = ""
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var statusMessage: String = ""
    var batchService: BatchService
    
    var body: some View {
        VStack {
            TextField("Group ID", text: $groupIdInput)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Announcement Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $content)
                .frame(minHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()

            Button("Post Announcement") {
                if let groupId = Int(groupIdInput) {
                    batchService.postAnnouncement(groupId: groupId, title: title, content: content) { success, message in
                        self.statusMessage = message
                        if success {
                            // Handle successful announcement post, e.g., clearing the fields or updating the UI
                            self.title = ""
                            self.content = ""
                        }
                    }
                } else {
                    self.statusMessage = "Please enter a valid group ID."
                }
            }
            .padding()
            
            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .padding()
            }
        }
    }
}

//Shows all the clubs
struct BatchListView: View {
    @State private var clubs: [Batch] = []
    var clubService: BatchService

    var body: some View {
        NavigationView {
            List(clubs) { club in
                VStack(alignment: .leading) {
                    // Display the id if it exists
                    if let id = club.id {
                        Text("ID: \(id)")
                    }
                    Text("Name: \(club.name)")
                    Text("Type: \(club.type)")
                    Text("Season: \(club.season)")
                    
                }
            }
            .navigationBarTitle("Clubs")
            .onAppear {
                clubService.fetchBatch { fetchedClubs in
                    self.clubs = fetchedClubs ?? []
                }
            }
        }
    }
}

struct PersonalClubListView: View {
    @State private var clubs: [Batch] = []
    var clubService: BatchService

    var body: some View {
        NavigationView {
            List(clubs) { club in
                VStack(alignment: .leading) {
                    
                    if let id = club.id {
                        Text("ID: \(id)")
                    }
                    Text("Name: \(club.name)")
                    Text("Type: \(club.type)")
                    Text("Season: \(club.season)")
                    // Optionally list members here
                }
            }
            .navigationBarTitle("Clubs")
            .onAppear {
                clubService.fetchIndvBatch { fetchedClubs in
                    self.clubs = fetchedClubs ?? []
                }
            }
        }
    }
}


struct CreateClubView: View {
    @State private var name: String = ""
    @State private var type: String = "CLUB"
    @State private var season: String = "YEAR_ROUND"
    var clubService: BatchService

    var body: some View {
        NavigationView {
            Form {
                TextField("Club Name", text: $name)
                
                Button("Create Club") {
                    let newClub = Batch(name: name, type: type, season: season)
                    clubService.createClub(club: newClub) { success in
                        // Handle the response, e.g., show an alert or update the UI
                    }
                }
            }
            .navigationBarTitle("Create Club")
        }
    }
}


struct JoinClubView: View {
    @State private var clubIdInput: String = ""
    @State private var joinStatusMessage: String = ""
    var clubService: BatchService

    var body: some View {
        VStack {
            TextField("Enter Club ID", text: $clubIdInput)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Join Club") {
                if let clubId = Int(clubIdInput) {
                    clubService.joinClub(with: clubId) { success, message in
                        self.joinStatusMessage = message
                        if success {
                            
                        } else {
                            
                        }
                    }
                } else {
                    self.joinStatusMessage = "Please enter a valid club ID."
                }
            }
            .padding()

            Text(joinStatusMessage)
                .padding()
        }
    }
}

struct LeaveClubView: View {
    @State private var clubIdInput: String = ""
    @State private var leaveStatusMessage: String = ""
    var clubService: BatchService

    var body: some View {
        VStack {
            TextField("Enter Club ID", text: $clubIdInput)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Leave Club") {
                if let clubId = Int(clubIdInput) {
                    clubService.leaveClub(with: clubId) { success, message in
                        self.leaveStatusMessage = message
                        if success {
                            // Handle successful leave, e.g., updating UI or showing confirmation
                        } else {
                            // Handle failure to leave, e.g., showing an error message
                        }
                    }
                } else {
                    self.leaveStatusMessage = "Please enter a valid club ID."
                }
            }
            .padding()

            Text(leaveStatusMessage)
                .padding()
        }
    }
}

struct PostEventView: View {
    @State private var groupId: String = ""
    @State private var eventType: String = "MEETING" // Default value
    @State private var locationId: String = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600) // Default 1 hour later
    @State private var description: String = ""
    @State private var statusMessage: String = ""
    var batchService: BatchService
    
    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Group ID", text: $groupId)
                    .keyboardType(.numberPad)

                Picker("Event Type", selection: $eventType) {
                    Text("Game").tag("GAME")
                    Text("Practice").tag("PRACTICE")
                    Text("Meeting").tag("MEETING")
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Location ID", text: $locationId)
                    .keyboardType(.numberPad)

                TextField("Description", text: $description)
            }

            Section(header: Text("Start Time")) {
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            }

            Section(header: Text("End Time")) {
                DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
            }

            Section {
                Button("Post Event") {
                    postEvent()
                }
            }
        }
        .navigationBarTitle("Create Event", displayMode: .inline)
        .alert(isPresented: .constant(!statusMessage.isEmpty)) {
            Alert(title: Text("Message"), message: Text(statusMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func postEvent() {
        guard let groupIdInt = Int(groupId), let locationIdInt = Int(locationId) else {
            self.statusMessage = "Please enter valid numeric IDs for group and location."
            return
        }

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)
        
        batchService.postGroupEvent(groupId: groupIdInt, eventType: eventType, locationId: locationIdInt, startTime: startTimeString, endTime: endTimeString, description: description) { success, message in
            self.statusMessage = message
            if success {
                // Handle successful event post, e.g., clearing the fields or updating the UI
                self.eventType = "MEETING" // Reset to default
                self.startTime = Date() // Reset to current time
                self.endTime = Date().addingTimeInterval(3600) // Reset to 1 hour later
                self.description = "" // Clear description
            }
        }
    }
}


struct UploadImageView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var selectedBatchId: Int?
    @State private var batchIdInput: String = ""
    var batchService: BatchService
    
    var body: some View {
        VStack {
            TextField("Enter Batch ID", text: $batchIdInput)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Select Photo") {
                showingImagePicker = true
            }
            .padding()

            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            
            Button("Upload Photo") {
                if let inputImage = inputImage, let batchId = Int(batchIdInput) {
                    guard let imageData = inputImage.jpegData(compressionQuality: 0.8) else { return }
                    batchService.updateGroupPhoto(groupId: batchId, photoData: imageData) { success, message in
                        

                    }
                }
            }
            .padding()
//            .disabled(selectedBatchId == nil || inputImage == nil)

        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        // Process the selected image
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct BatchView: View {
    
    var clubService: BatchService
    
    var body: some View {
        TabView{
            BatchListView(clubService: clubService)
                .tabItem {
                    Label("Clubs", systemImage: "list.bullet")
                }
            CreateClubView(clubService: clubService)
                .tabItem {
                    Label("Create", systemImage: "plus.circle")
                }
            BatchDetailView(batchService: clubService)
                .tabItem {
                    Label("Details", systemImage: "info.circle")
                }
            BatchDeleteView(clubService: clubService)
                .tabItem {
                    Label("Delete", systemImage: "minus.circle")
                }
            PersonalClubListView(clubService: clubService)
                .tabItem{
                    Label("Personal", systemImage: "")
                }
        }
    }
    
}

struct LocationView: View {
    
    var LocationService: LocationService
    
    var body: some View {
        TabView{
            LocationsListView(locationService: LocationService)
                .tabItem{
                    Label("All Locations", systemImage: "map")
                }
            CreateLocationView(locationService: LocationService)
                .tabItem{
                    Label("Create A Location", systemImage: "map")
                }
            LocationDetailView(locationService: LocationService)
                .tabItem{
                    Label("Find Location Based on Id", systemImage: "map")
                }
            DeleteLocationView(locationService: LocationService)
                .tabItem{
                    Label("Delete Location", systemImage: "map")
                }
        }
    }
    
}
struct Clubmainthesecond: View {
    @AppStorage("token") var token: String?
    
    var body: some View {
        if let safeToken = token {
            let clubService = BatchService(token: safeToken)
            let LocationService = LocationService(token: safeToken)
            TabView {
                BatchView(clubService: clubService)
                    .tabItem {
                        Label("CLUBS", systemImage: "list.bullet")
                    }
                
                LocationView(LocationService: LocationService)
                    .tabItem{
                        Label("LOCATIONS", systemImage: "map")
                    }
                
                
                JoinClubView(clubService: clubService)
                    .tabItem{
                        Label("Join Club", systemImage: "")
                    }
                LeaveClubView(clubService: clubService)
                    .tabItem{
                        Label("Leave Club", systemImage: "")
                    }
                UploadImageView(batchService: clubService)
                    .tabItem {
                        Label("Upload Image", systemImage: "photo.on.rectangle")
                    }
                UserRoleUpdateView()
                    .tabItem {
                        Label("Group Role", systemImage: "")
                    }
                PostAnnouncementView(batchService: clubService)
                    .tabItem {
                        Label("Post Announcement", systemImage: "megaphone")
                    }
                EditAnnouncementView(batchService: clubService)
                    .tabItem {
                        Label("Edit Announcement", systemImage: "megaphone")
                    }
                DeleteAnnouncementView(batchService: clubService)
                    .tabItem {
                        Label("Delete Announcement", systemImage: "megaphone")
                    }
                PostEventView(batchService: clubService)
                        .tabItem {
                            Label("Post Event", systemImage: "calendar")
                        }
                
                EditEventView(batchService: clubService)
                    .tabItem {
                        Label("Edit Event", systemImage: "pencil.circle")
                    }

                DeleteEventView(batchService: clubService)
                    .tabItem {
                        Label("Delete Event", systemImage: "pencil.circle")
                    }
            }
        } else {
            Text("Please log in to manage Groups.")
        }
    }
}



import SwiftUI

struct EditEventView: View {
    @State private var eventId: String = ""
    @State private var groupId: String = ""
    @State private var eventType: String = "MEETING" // Default value
    @State private var locationId: String = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600) // Default 1 hour later
    @State private var description: String = ""
    @State private var statusMessage: String = ""
    var batchService: BatchService

    var body: some View {
        Form {
            Section(header: Text("Edit Event")) {
                TextField("Event ID", text: $eventId)
                    .keyboardType(.numberPad)
                
                TextField("Group ID", text: $groupId)
                    .keyboardType(.numberPad)

                Picker("Event Type", selection: $eventType) {
                    Text("Game").tag("GAME")
                    Text("Practice").tag("PRACTICE")
                    Text("Meeting").tag("MEETING")
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Location ID", text: $locationId)
                    .keyboardType(.numberPad)

                TextField("Description", text: $description)
            }

            Section(header: Text("Start Time")) {
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            }

            Section(header: Text("End Time")) {
                DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
            }

            Section {
                Button("Save Changes") {
                    editEvent()
                }
            }
        }
        .navigationBarTitle("Edit Event", displayMode: .inline)
        .alert(isPresented: .constant(!statusMessage.isEmpty)) {
            Alert(title: Text("Message"), message: Text(statusMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func editEvent() {
        guard let eventIdInt = Int(eventId),
              let groupIdInt = Int(groupId),
              let locationIdInt = Int(locationId) else {
            self.statusMessage = "Please enter valid numeric IDs for event, group, and location."
            return
        }

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)

        batchService.editEvent(eventId: eventIdInt, groupId: groupIdInt, eventType: eventType, locationId: locationIdInt, startTime: startTimeString, endTime: endTimeString, description: description) { success, message in
            self.statusMessage = message
            if success {
                // Optionally reset the form or update UI
            }
        }
    }
}

struct DeleteEventView: View {
    @State private var announcementId: String = ""
    @State private var feedbackMessage: String? = nil
    
    var batchService: BatchService // Assume this is passed in or initialized elsewhere

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Delete Event")) {
                    TextField("Event ID", text: $announcementId)
                        .keyboardType(.numberPad)
                    Button("Delete") {
                        guard let announcementIdInt = Int(announcementId) else {
                            feedbackMessage = "Announcement ID must be a number."
                            return
                        }
                        batchService.deleteEvent(eventId: announcementIdInt) { success, message in
                            feedbackMessage = message
                        }
                    }
                }
                
                if let feedback = feedbackMessage {
                    Section(header: Text("Feedback")) {
                        Text(feedback)
                    }
                }
            }
            .navigationTitle("Delete Announcement")
        }
    }
}

struct DeleteAnnouncementView: View {
    @State private var announcementId: String = ""
    @State private var feedbackMessage: String? = nil
    
    var batchService: BatchService // Assume this is passed in or initialized elsewhere

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Delete Announcement")) {
                    TextField("Announcement ID", text: $announcementId)
                        .keyboardType(.numberPad)
                    Button("Delete") {
                        guard let announcementIdInt = Int(announcementId) else {
                            feedbackMessage = "Announcement ID must be a number."
                            return
                        }
                        batchService.deleteAnnouncement(announcementId: announcementIdInt) { success, message in
                            feedbackMessage = message
                        }
                    }
                }
                
                if let feedback = feedbackMessage {
                    Section(header: Text("Feedback")) {
                        Text(feedback)
                    }
                }
            }
            .navigationTitle("Delete Announcement")
        }
    }
}

struct EditAnnouncementView: View {
    @State private var announcementId: String = ""
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var feedbackMessage: String? = nil
    
    var batchService: BatchService // Assume this is passed in or initialized elsewhere

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Announcement Details")) {
                    TextField("Announcement ID", text: $announcementId)
                        .keyboardType(.numberPad)
                    TextField("Title", text: $title)
                    TextField("Content", text: $content)
                }
                
                Section {
                    Button("Edit Announcement") {
                        guard let announcementIdInt = Int(announcementId) else {
                            feedbackMessage = "Announcement ID must be a number."
                            return
                        }
                        batchService.editAnnouncement(announcementId: announcementIdInt, title: title, content: content) { success, message in
                            feedbackMessage = message
                        }
                    }
                }
                
                if let feedback = feedbackMessage {
                    Section(header: Text("Feedback")) {
                        Text(feedback)
                    }
                }
            }
            .navigationTitle("Edit Announcement")
        }
    }
}

struct UserRoleUpdateView: View {
    @AppStorage("token") var token: String?
    @State private var groupId: String = ""
    @State private var userId: String = ""
    @State private var newRole: String = "MEMBER" 
    @State private var feedbackMessage: String? = nil
    
    
    private var batchService: BatchService {
            BatchService(token: token ?? "")
        }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group ID", text: $groupId)
                        .keyboardType(.numberPad)
                    TextField("User ID", text: $userId)
                        .keyboardType(.numberPad)
                    Picker("Role", selection: $newRole) {
                        Text("Leader").tag("LEADER")
                        Text("Officer").tag("OFFICER")
                        Text("Member").tag("MEMBER")
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button("Update Role") {
                        submitRoleUpdate()
                    }
                    .disabled(groupId.isEmpty || userId.isEmpty)
                }
                
                if let feedback = feedbackMessage {
                    Section(header: Text("Feedback")) {
                        Text(feedback)
                    }
                }
            }
            .navigationTitle("Update User Role")
        }
    }
    
    private func submitRoleUpdate() {
        guard let groupIdInt = Int(groupId), let userIdInt = Int(userId) else {
            feedbackMessage = "Group ID and User ID must be numbers."
            return
        }
        
        batchService.updateUserRole(groupId: groupIdInt, userId: userIdInt, newRole: newRole) { success, message in
            feedbackMessage = message
        }
    }
}


class LocationService {
    let baseURL = URL(string: "https://hub-dev.stmarksschool.org/v1/location")!
    let token: String
        
    init(token: String) {
        self.token = token
    }
    
    func fetchLocations(completion: @escaping ([Location]?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching locations: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let locations = try JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    completion(locations)
                }
            } catch {
                print("Error decoding locations: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func createLocation(location: Location, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(location)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error creating location: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
//                print("Failed to create location with status code: \(String(describing: response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
    
    func fetchLocationById(_ id: Int, completion: @escaping (Location?) -> Void) {
        let endpoint = baseURL.appendingPathComponent("\(id)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error fetching location by ID: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                DispatchQueue.main.async {
                    completion(location)
                }
            } catch {
                print("Error decoding location: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func deleteLocationById(_ id: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = baseURL.appendingPathComponent("\(id)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error deleting location: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                print("Failed to delete location with status code: \(String(describing: response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
}

// LocationsListView.swift
struct LocationsListView: View {
    @State private var locations: [Location] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    var locationService: LocationService

    var body: some View {
        List(locations) { location in
            VStack(alignment: .leading) {
                Text("ID: \(location.id ?? 0)")
                Text("Building: \(location.buildingName)")
                Text("Room: \(location.roomName)")
            }
        }
        .onAppear {
            locationService.fetchLocations { fetchedLocations in
                if let locations = fetchedLocations {
                    self.locations = locations
                } else {
                    self.alertMessage = "Failed to fetch locations."
                    self.showAlert = true
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Locations")
    }
}


// CreateLocationView.swift
struct CreateLocationView: View {
    @State private var buildingName: String = "Athletics"
    @State private var roomName: String = ""
    @State private var id: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var locationService: LocationService

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Building Information")) {
                    TextField("Building Name", text: $buildingName)
                    TextField("Room Name", text: $roomName)
                    
                }
                
                Section {
                    Button("Create Location") {
                        createLocation()
                    }
                }
            }
            .navigationTitle("New Location")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func createLocation() {
        let location = Location(buildingName: buildingName, roomName: roomName)
        locationService.createLocation(location: location) { success in
            if success {
                alertMessage = "Location successfully created."
                buildingName = ""
                roomName = ""
            } else {
                alertMessage = "Failed to create location."
            }
            showingAlert = true
        }
    }

}

// DeleteLocationView.swift
struct DeleteLocationView: View {
    @State private var locationIdInput: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var locationService: LocationService

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Location ID", text: $locationIdInput)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray, width: 1)
                .padding()

            Button("Delete Location") {
                self.deleteLocation()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .navigationTitle("Delete Location")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func deleteLocation() {
        guard let locationId = Int(locationIdInput), !locationIdInput.isEmpty else {
            alertTitle = "Invalid Input"
            alertMessage = "Please enter a valid location ID."
            showingAlert = true
            return
        }

        locationService.deleteLocationById(locationId) { success in
            if success {
                alertTitle = "Success"
                alertMessage = "Location successfully deleted."
            } else {
                alertTitle = "Failed"
                alertMessage = "Failed to delete location. Please try again."
            }
            showingAlert = true
            locationIdInput = "" // Clear input
        }
    }
}


// LocationDetailView.swift
struct LocationDetailView: View {
    @State private var locationIdInput: String = ""
    @State private var location: Location?
    @State private var showingAlert = false
    @State private var alertMessage: String?
    var locationService: LocationService

    var body: some View {
        VStack {
            TextField("Enter Location ID", text: $locationIdInput)
                .keyboardType(.numberPad)
                .padding()
            
            Button("Fetch Location Details") {
                guard let locationId = Int(locationIdInput) else {
                    alertMessage = "Please enter a valid numeric ID."
                    showingAlert = true
                    return
                }
                fetchLocation(withId: locationId)
            }
            .padding()

            if let location = location {
                Text("ID: \(location.id ?? 0)").padding()
                Text("Building Name: \(location.buildingName)").padding()
                Text("Room Name: \(location.roomName)").padding()
            } else {
                Text("Location details will appear here.").padding()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage ?? "An error occurred"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func fetchLocation(withId id: Int) {
        locationService.fetchLocationById(id) { fetchedLocation in
            if let location = fetchedLocation {
                self.location = location
            } else {
                self.alertMessage = "Failed to fetch location."
                self.showingAlert = true
            }
        }
    }
}


//fafa
//import SwiftUI
//
//struct CreateGroupEventView: View {
//  @State private var title: String = ""
//  @State private var description: String = ""
//  @State private var date = Date()
//  @State private var showingAlert = false
//  @State private var errorMessage: String? = nil
//
//  func createGroupEvent() {
//    // Replace "YOUR_GROUP_ID" with the actual group ID
//    guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/group/YOUR_GROUP_ID/event") else {
//      print("Invalid URL")
//      return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    // Replace "YOUR_TOKEN" with your actual token
//    request.setValue("Bearer YOUR_TOKEN", forHTTPHeaderField: "Authorization")
//
//    let encoder = JSONEncoder()
//    let event = GroupEvent(title: title, description: description, date: date)
//    let eventData = try! encoder.encode(event)
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//      DispatchQueue.main.async {
//        if let error = error {
//          self.errorMessage = error.localizedDescription
//          self.showingAlert = true
//          return
//        }
//
//        guard let data = data, let response = response as? HTTPURLResponse else {
//          self.errorMessage = "Failed to receive data"
//          self.showingAlert = true
//          return
//        }
//
//        if response.statusCode == 200 {
//          self.errorMessage = "Event created successfully!"
//        } else {
//          self.errorMessage = "Failed to create event. Status code: \(response.statusCode)"
//        }
//        self.showingAlert = true
//      }
//    }
//    task.resume()
//  }
//
//  var body: some View {
//    VStack {
//      TextField("Event Title", text: $title)
//        .padding()
//
//      TextEditor("Description (optional)")
//        .frame(minHeight: 100)
//        .padding()
//
//      DatePicker("Date", selection: $date)
//        .padding()
//
//      Button("Create Event") {
//        createGroupEvent()
//      }
//      .padding()
//
//      if let errorMessage = errorMessage {
//        Text(errorMessage)
//          .foregroundColor(.red)
//          .alert(isPresented: $showingAlert) {
//            Button("OK") { }
//          }
//      }
//    }
//  }
//}
//
//struct GroupEvent: Encodable {
//  let title: String
//  let description: String
//  let date: Date
//
//  // Assuming "startTime" and "endTime" are required by the backend
//  // You can set them here or add them to the state variables of the view
//  private enum CodingKeys: String, CodingKey {
//    case title, description
//    case startTime = "startTime" // Replace with actual key name if different
//    case endTime = "endTime" // Replace with actual key name if different
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(title, forKey: .title)
//    try container.encode(description, forKey: .description)
//    // Encode start time and end time here if required by the backend
//  }
//}
//
//struct CreateGroupEventView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateGroupEventView()
//  }
//}
//
//
//import SwiftUI
//
//struct GroupManagementView: View { // Or name this whatever you like
//
//    // ---- Update Group Role Functionality ----
//    @State private var groupId = ""
//    @State private var userId = ""
//    @State private var role = Role.member
//    @State private var updateRoleErrorMessage: String? = nil
//    @State private var showingUpdateRoleAlert = false
//
//    enum Role: String, CaseIterable {
//        case leader
//        case officer
//        case member
//    }
//
//    func updateGroupRole() {
//        // ... (Implementation from previous examples)
//    }
//
//    // ---- Create Group Event Functionality ----
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var date = Date()
//    @State private var startTime = Date()
//    @State private var endTime = Date()
//    @State private var createEventErrorMessage: String? = nil
//    @State private var showingCreateEventAlert = false
//
//    func createGroupEvent() {
//         // ... (Implementation from previous examples)
//    }
//
//    // ---- Main View ----
//    var body: some View {
//        VStack {
//            // Update Role Section
//            Text("Update Group Role")
//                .font(.title2)
//            TextField("Group ID", text: $groupId)
//                .keyboardType(.numberPad)
//            TextField("User ID", text: $userId)
//                .keyboardType(.numberPad)
//            Picker("Role", selection: $role) {
//                ForEach(Role.allCases, id: \.self) { role in
//                    Text(role.rawValue.capitalized).tag(role)
//                }
//            }
//            Button("Update Role") { updateGroupRole() }
//            if let updateRoleErrorMessage = updateRoleErrorMessage {
//                Text(updateRoleErrorMessage).foregroundColor(.red)
//                    .alert(isPresented: $showingUpdateRoleAlert) {
//                        Button("OK") { }
//                    }
//            }
//
//           // Create Event Section
//           Text("Create Group Event")
//                .font(.title2)
//           TextField("Event Title", text: $title)
//           TextEditor("Description (optional)")
//               .frame(minHeight: 100)
//           DatePicker("Date", selection: $date)
//           DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
//           DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
//           Button("Create Event") { createGroupEvent() }
//           if let createEventErrorMessage = createEventErrorMessage {
//               Text(createEventErrorMessage).foregroundColor(.red)
//                    .alert(isPresented: $showingCreateEventAlert) {
//                        Button("OK") { }
//                    }
//            }
//        }
//        .padding() // Apply padding to the overall VStack
//    }
//}
//
//
//// The Encodable structs and the preview would remain the same:
//struct RoleRequest: Encodable { /* ... */ }
//struct GroupEvent: Encodable { /* ... */ }
//struct GroupManagementView_Previews: PreviewProvider { /* ... */ }

