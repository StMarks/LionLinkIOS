import SwiftUI
import Combine

struct Permission: Codable {
    let id: Int
    let name: String
    let key: String
}

struct Role: Codable {
    let id: Int
    let name: String
    let permissions: [Permission]
}

struct UserProfile: Codable, Identifiable {
    let id: Int
    let firstName, lastName: String
    let preferredName: String?
    let gradYear: Int
    let email: String
    let picture: String?
    let roleId: Int
    let role: Role
}

extension UserProfile {
    func hasSuperAdminPermission() -> Bool {
        return role.permissions.contains { $0.key == "SUPERADMIN" }
    }
}

// ViewModel for managing the profile data and actions
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
        @Published var profileImage: UIImage?
        @AppStorage("token") var token: String?

        init() {
            fetchUserProfile()
        }

    func fetchUserProfile() {
        guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/user"),
              let token = token else {
            print("Invalid URL or Token is nil")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                // Printing out the response data for debugging (can be removed in production).
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")

                DispatchQueue.main.async {
                    do {
                        self?.userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                        // If 'picture' is nil, 'loadProfileImage' will not be called.
                        if self?.userProfile?.picture != nil {
                            self?.loadProfileImage()
                        }
                    } catch {
                        print("Error decoding user profile: \(error)")
                    }
                }
            } else if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }.resume()
    }



    func loadProfileImage() {
        guard let urlString = userProfile?.picture, let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.profileImage = image
                }
            } else if let error = error {
                print("Error loading profile image: \(error.localizedDescription)")
            }
        }.resume()
    }

    func uploadProfilePicture(image: UIImage) {
        guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/user/photo"),
                      let token = token else {
                    print("Invalid URL or Token is nil")
                    return
                }

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not convert image to Data")
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        print("Successfully uploaded profile picture")
                        self?.fetchUserProfile() // Reload the user profile
                    } else {
                        print("Failed to upload profile picture with status code: \(httpResponse.statusCode)")
                        if let data = data, let string = String(data: data, encoding: .utf8) {
                            print("Server error response: \(string)")
                        }
                    }
                }
            } else if let error = error {
                print("Error uploading profile picture: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// SwiftUI View for displaying and updating the user's profile
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var showingPrivacyPolicy = false
    @State private var inputImage: UIImage?
    @AppStorage("token") var token: String?
    
    var body: some View {
            VStack(spacing: 20) {
                Spacer().frame(height: 40) // Adjust the spacing as per your design
                
                // Profile picture
                ZStack {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    } else {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 130, height: 130)
                            .overlay(Text("Tap to\nadd photo").foregroundColor(.white))
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                // User's full name
                Text("\(viewModel.userProfile?.firstName ?? "") \(viewModel.userProfile?.lastName ?? "")")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Grad year
                if let gradYear = viewModel.userProfile?.gradYear {
                    Text("Class of \(gradYear)")
                        .font(.headline)
                }
                
                // Email address
                Text(viewModel.userProfile?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer() // Pushes everything to the top
                NavigationLink("Privacy Policy", destination: PrivacyPolicyView(), isActive: $showingPrivacyPolicy)
                                .padding()
                            
                Button("Log Out") {
                    // Clear the token from AppStorage
                    token = nil
                    // Remove the token from UserDefaults directly
                    UserDefaults.standard.removeObject(forKey: "token")
                    // Force UserDefaults to save changes immediately
                    UserDefaults.standard.synchronize() // This is deprecated and generally not needed
                }

                            .padding()
                            .foregroundColor(.red)
            }
            .padding(.horizontal)
            .navigationBarTitle("Profile", displayMode: .large)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                ImagePicker(image: self.$viewModel.profileImage)
            }
            .onAppear {
                viewModel.fetchUserProfile()
            }
        }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        viewModel.profileImage = inputImage
        viewModel.uploadProfilePicture(image: inputImage)
    }
}

