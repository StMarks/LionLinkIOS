import SwiftUI

struct CalendarNavBar: View {
    let month: String
    @AppStorage("token") var token: String?
    @State private var profileImage: Image = Image(systemName: "person.fill")
    @State private var userProfile: UserProfile?

    var body: some View {
        HStack {
            NavigationLink(
                destination: Hubmain().navigationBarBackButtonHidden(true),
                label: {
                    Image("lion")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            )
            
            Text(month)
                .font(.title)
                .bold()
                
            Spacer()

            NavigationLink(
                destination: Profile().navigationBarBackButtonHidden(false),
                label: {
                    profileImage
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            )
        }
        .padding()
        .onAppear {
            fetchUserProfile()
        }
    }
    
    func fetchUserProfile() {
        guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/user") else {
            print("Invalid URL for user profile.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error occurred: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let decodedUser = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.userProfile = decodedUser
                    loadProfileImage(from: decodedUser.picture)
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }
    
    // Function to load the profile image
    func loadProfileImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}
