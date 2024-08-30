import SwiftUI

struct Profile: View {
    @AppStorage("token") var token: String?
    @State private var user: UserProfile?
    @State private var showingImagePicker = false
    @State private var profileImage: Image?
    @State private var inputUIImage: UIImage?
    @State private var isLoggingOut = false
    @State private var shouldNavigateToContentView = false
    
    var body: some View {
            VStack(spacing: 20) {
                Spacer()

                // Profile Image
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }

                // User Information
                if let user = user {
                    Text("Welcome \(user.nickName ?? user.firstName)")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("\(user.firstName) \(user.lastName)")
                        .font(.headline)

                    Text(user.email)
                        .font(.subheadline)

                    Text("Class of \(String(user.gradYear))")
                        .font(.subheadline)

                    // Upload Photo Button
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Text("Upload New Photo")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            self.fetchUserProfile()
                        }
                }

                Spacer()

                // Privacy Policy Button
                NavigationLink("Privacy Policy", destination: PrivacyPolicyView())
                .font(.footnote)
                .foregroundColor(.gray)

                // Logout Button
                Button("Logout") {
                    self.isLoggingOut = true
                }
                .foregroundColor(.red)
                .padding(.bottom)
            }
            .padding()
            .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
                ImagePickers(image: self.$inputUIImage)
            }
            .sheet(isPresented: $isLoggingOut) {
                        LogoutView(onLoggedOut: {
                            self.token = nil
                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
                            self.isLoggingOut = false
                        })
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
//                    .navigate(using: $shouldNavigateToContentView, destination: type(of: LionLinkApp()).init)
        }

    
    // MARK: - Networking
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
            
            // Print the raw data as a string
            if let rawResponseString = String(data: data, encoding: .utf8) {
                print("Response data string:\n\(rawResponseString)")
            }
            
            do {
                let decodedUser = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.user = decodedUser
                    if let picture = decodedUser.picture, let url = URL(string: picture) {
                        self.loadProfileImage(from: url)
                    } else {
                        self.profileImage = Image(systemName: "person.crop.circle.badge.plus")
                    }
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }


    func loadProfileImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
    
    func uploadImage() {
        guard let inputImage = inputUIImage else { return }
            
        profileImage = Image(uiImage: inputImage)
            
        uploadProfilePicture(image: inputImage)
    }
        
        func uploadProfilePicture(image: UIImage) {
            guard let url = URL(string: "https://hub-dev.stmarksschool.org/v1/user/photo") else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
                
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                var body = Data()
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                
                request.httpBody = body
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Upload error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    return
                }
                
                
                    DispatchQueue.main.async {
                                
                                self.inputUIImage = nil
                                
                                if let mimeType = response.mimeType, mimeType == "application/json", let data = data {
                                    do {
                                        let updatedUser = try JSONDecoder().decode(UserProfile.self, from: data)
                                        self.user = updatedUser
                                    } catch {
                                        print("JSON update decoding error: \(error)")
                                    }
                                }
                            }
            }.resume()
        }
    func updateProfileImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                    self.inputUIImage = uiImage
                }
            }
        }.resume()
        DispatchQueue.main.async {
            self.inputUIImage = nil
        }
    }
}

// MARK: - Models
struct UserProfile: Codable {
    let id: Int
    let firstName, lastName, nickName: String
    let gradYear: Int
    let email: String
    let googleId: String
    let roleId: Int
    let picture: String?
    let role: UserRole

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, nickName = "nickName", gradYear, email, googleId, roleId, picture, role
    }
}

struct UserRole: Codable {
    let id: Int
    let name: String
    let permissions: [RolePermission]
}

struct RolePermission: Codable {
    let roleId: Int
    let permissionId: Int
    let role: PermissionRole
    let permission: Permission
}

struct PermissionRole: Codable {
    let id: Int
    let name: String
}

struct Permission: Codable {
    let id: Int
    let name: String
    let key: String
}


// MARK: - Image Picker
struct ImagePickers: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?

        init(image: Binding<UIImage?>) {
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}


