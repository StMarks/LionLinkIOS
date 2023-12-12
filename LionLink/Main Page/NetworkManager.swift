import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchSchedule(forUserToken token: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://hub-dev.stmarksschool.org/student/schedule" // Replace with your actual endpoint
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    
}
