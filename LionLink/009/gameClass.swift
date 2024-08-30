import Foundation

class GameService: ObservableObject {
    let baseURL = URL(string: "https://hub-dev.stmarksschool.org/v1/009")!
    let token: String
    
    init(token: String) {
        self.token = token
    }
    func clearGame(completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("clear")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(false, "Network error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(false, "Invalid response from server.")
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        completion(true, "Game cleared.")
                    } else {
                        completion(false, "Failed to clear game.")
                    }
                }
            }.resume()
        }

        func addAllUsersToGame(completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("add-all")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(false, "Network error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(false, "Invalid response from server.")
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        completion(true, "All users added to game.")
                    } else {
                        completion(false, "Failed to add all users to game.")
                    }
                }
            }.resume()
        }
    
    
    func addUserToGame(userId: String, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("add/\(userId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error occurred: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Error adding user to game: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(false, "Failed to add user, received status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, "User added successfully.")
            }
        }.resume()
    }
    
    func roundMinCheck(startDate: Int, endDate: Int, minimum: Int, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("admin/round-minimum")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error occurred: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Error adding user to game: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(false, "Failed to add user, received status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, "User added successfully. \(response)")
            }
        }.resume()
    }

    func removeUserFromGame(userId: String, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("remove/\(userId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Attempting to remove user with ID: \(userId)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error occurred: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Error removing user from game: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Failed to cast response to HTTPURLResponse")
                DispatchQueue.main.async {
                    completion(false, "Invalid response from server.")
                }
                return
            }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    completion(true, "User removed successfully.")
                } else {
                    
                    let errorMessage = self.parseErrorMessage(data: data)
                    completion(false, "Failed to remove user, received status code: \(httpResponse.statusCode) with message: \(errorMessage)")
                }
            }
        }.resume()
    }

    func fetchAllPlayers(completion: @escaping (Bool, [Player]?) -> Void) {
        let endpoint = baseURL.appendingPathComponent("admin/players")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("Making request to \(endpoint)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            print("Received response")
            if let rawResponseString = String(data: data!, encoding: .utf8) {
                print("Response data string:\n\(rawResponseString)")
            }
            
            if let error = error {
                print("Network error occurred: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            } else {
                print("Failed to cast response to HTTPURLResponse")
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                print("Request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            do {
                let players = try JSONDecoder().decode([Player].self, from: data)
                print("Successfully decoded player list: \(players)")
                DispatchQueue.main.async {
                    completion(true, players)
                }
            } catch let decodeError {
                print("JSON decoding error: \(decodeError)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }.resume()
    }

    //alive player for new target email
    //in body
    //new target email
    
    func setNewTargetForUser(tagPlayerId: Int, userTargetId: Int, completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("update/\(tagPlayerId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["userTargetId": userTargetId]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, "Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid response from server.")
                    }
                    return
                }
                
                let statusCode = httpResponse.statusCode
                DispatchQueue.main.async {
                    if statusCode == 200 {
                        completion(true, "Target updated successfully.")
                    } else {
                        let message = self.parseErrorMessage(data: data)
                        completion(false, "Failed to update target: \(message)")
                    }
                }
            }.resume()
        }
    
    func eliminateUserFromGame(userId: Int, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("admin/eliminate/user/\(userId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    completion(false, "Invalid response from server.")
                    return
                }

                if httpResponse.statusCode == 200 {
                    let message = self.parseSuccessMessage(data: data)
                    completion(true, message)
                } else {
                    let errorMessage = self.parseErrorMessage(data: data)
                    completion(false, "Failed to eliminate player: \(errorMessage)")
                }
            }
        }.resume()
    }
    
        // Reroll target assignments (MONITOR PERMISSION)
        func rerollTargetAssignments(completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("reroll")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, "Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid response from server.")
                    }
                    return
                }
                
                let statusCode = httpResponse.statusCode
                DispatchQueue.main.async {
                    if statusCode == 200 {
                        completion(true, "Targets rerolled successfully.")
                    } else {
                        let message = self.parseErrorMessage(data: data)
                        completion(false, "Failed to reroll targets: \(message)")
                    }
                }
            }.resume()
        }

        // Get game details (NON-ADMIN)
    func getGameDetails(completion: @escaping (Bool, GameDetails?) -> Void) {
        let endpoint = baseURL.appendingPathComponent("game")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let rawResponseString = String(data: data!, encoding: .utf8) {
                print("GAME DETAILS:\n\(rawResponseString)")
            }
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error occurred: \(error.localizedDescription)")
                    completion(false, nil)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200, let data = data else {
                    print("Invalid response from the server or bad status code.")
                    completion(false, nil)
                    return
                }
                
                do {
                    let gameDetails = try JSONDecoder().decode(GameDetails.self, from: data)
                    completion(true, gameDetails)
                } catch {
                    print("JSON decoding error: \(error)")
                    completion(false, nil)
                }
            }
        }.resume()
    }



    func getTagPlayer(tagPlayerId: Int, completion: @escaping (Bool, Player?) -> Void) {
            let endpoint = baseURL.appendingPathComponent("userTagPlayer/\(tagPlayerId)")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Network error: \(error.localizedDescription)")
                        completion(false, nil)
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Failed to receive HTTP response.")
                        completion(false, nil)
                        return
                    }

                    if httpResponse.statusCode == 200, let data = data {
                        if let rawResponseString = String(data: data, encoding: .utf8) {
                            print("Response data string:\n\(rawResponseString)")
                        }
                        do {
                            let player = try JSONDecoder().decode(Player.self, from: data)
                            completion(true, player)
                        } catch {
                            print("Decoding error: \(error)")
                            completion(false, nil)
                        }
                    } else {
                        print("Received non-200 status code.")
                        completion(false, nil)
                    }
                }
            }.resume()
        }
        // Function for a player to eliminate their target
    func eliminateTarget(completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("eliminate")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, "Network error: \(error.localizedDescription)")
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid response from server.")
                    }
                    return
                }

                let statusCode = httpResponse.statusCode
                DispatchQueue.main.async {
                    if statusCode == 200 {
                        let message = self.parseSuccessMessage(data: data)
                        completion(true, message)
                    } else {
                        let errorMessage = self.parseErrorMessage(data: data)
                        completion(false, "Failed to eliminate target: \(errorMessage)")
                    }
                }
            }.resume()
        }

        // Function to report a player eliminated by another player
        func reportEliminatedByOther(completion: @escaping (Bool, String) -> Void) {
            let endpoint = baseURL.appendingPathComponent("eliminated")
            var request = URLRequest(url: endpoint)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, "Network error: \(error.localizedDescription)")
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid response from server.")
                    }
                    return
                }

                let statusCode = httpResponse.statusCode
                DispatchQueue.main.async {
                    if statusCode == 200 {
                        let message = self.parseSuccessMessage(data: data)
                        completion(true, message)
                    } else {
                        let errorMessage = self.parseErrorMessage(data: data)
                        completion(false, "Failed to report elimination: \(errorMessage)")
                    }
                }
            }.resume()
        }

        // Helper function to parse success messages
        private func parseSuccessMessage(data: Data?) -> String {
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dictionary = json as? [String: Any], let message = dictionary["message"] as? String {
                return message
            }
            return "Success, but no message provided."
        }

        // Helper function to parse error messages
        private func parseErrorMessage(data: Data?) -> String {
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []), let dictionary = json as? [String: Any], let message = dictionary["message"] as? String {
                return message
            }
            return "An unknown error occurred."
        }
}

