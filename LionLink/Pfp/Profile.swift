//import SwiftUI
//
//struct Profile: View {
//    @AppStorage("token") var token: String?
//    @AppStorage("id") var id: String?
//    @State private var user: UserProfile?
//    @State private var showingImagePicker = false
//    @State private var profileImage: Image?
//    @State private var inputUIImage: UIImage?
//    @State private var isLoggingOut = false
//    @State private var isDeletingAccount = false
//    @State private var shouldNavigateToContentView = false
//    @State private var showingAlert = false
//    @StateObject var viewModel = SafariViewModel()
//    var body: some View {
//        ZStack{
//            
//            VStack(spacing: 20) {
//                Spacer()
//                
//                // Profile Image
//                if let profileImage = profileImage {
//                    profileImage
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 150, height: 150)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                        .shadow(radius: 10)
//                } else {
//                    Image(systemName: "person.crop.circle.badge.plus")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 150)
//                        .foregroundColor(.gray)
//                }
//                
//                // User Information
//                if let user = user {
//                    Text("Welcome \(user.nickName)")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    Text("\(user.firstName) \(user.lastName)")
//                        .font(.headline)
//                    
//                    Text(user.email)
//                        .font(.subheadline)
//                    
//                    Text("Class of \(String(user.gradYear))")
//                        .font(.subheadline)
//                    
//                    // Upload Photo Button
//                    Button(action: {
//                        self.showingImagePicker = true
//                    }) {
//                        Text("Upload New Photo")
//                            .font(.body)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                } else {
//                    Text("Loading...")
//                        .onAppear {
//                            self.fetchUserProfile()
//                        }
//                }
//                
//                Spacer()
//                
//                // Privacy Policy Button
//                NavigationLink("Privacy Policy", destination: PrivacyPolicyView())
//                    .font(.footnote)
//                    .foregroundColor(.gray)
//                
//                // Logout Button
//                
//                Button("Logout") {
//                    //                                self.token=""
//                    //                                viewModel.logout()
//                    self.isLoggingOut = true
//                    //                                self.token = nil
//                    //                                self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                }
//                
//                .foregroundColor(.blue)
//                .padding(.bottom)
//                //            NavigationLink("Logout", destination: ContentView())
//                //                .foregroundStyle(.red)
//                //                .simultaneousGesture(TapGesture().onEnded {
//                //                    self.token = nil
//                //                }
//                //                )
//                Button("Delete Account") {
//                    //                                self.token=""
//                    //                                viewModel.logout()
//                    self.isDeletingAccount = true
//                    
//                    //                                self.token = nil
//                    //                                self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                }
//                .foregroundColor(.red)
//                    .padding(.bottom)
//            }
//            .padding()
//            .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
//                ImagePickers(image: self.$inputUIImage)
//            }
//            .fullScreenCover(isPresented: $isLoggingOut) {
//                
//                    
//                        SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!).onAppear(){
//                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                self.token = ""
//                                self.isLoggingOut = false
//                            }
//                        }
////                        .scaleEffect(0.01).offset(CGSize(width: 100.0, height: 100.0))
//                    
//                    
//                    
//                    //                        .onAppear(){
//                    //                            self.token = nil
//                    //                            self.isLoggingOut = false
//                    //                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                    //
//                    //                        }
//                    
//                    
//                
//            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.inline)
//           
//            .fullScreenCover(isPresented: $isDeletingAccount) {
//                
//                    
//                        SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!).onAppear(){
//                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                            print("\(user?.id ?? 00)")
////                            self.delUserProfile(userId: 8398702)
//                            DeleteAcc(userId: user?.id)
//                            print("\(user?.id ?? 00)")
//                            self.token = ""
//                            self.isDeletingAccount = false
//                            
//                        }
////                        .scaleEffect(0.01).offset(CGSize(width: 100.0, height: 100.0))
//                    
//                    
//                    
//                    //                        .onAppear(){
//                    //                            self.token = nil
//                    //                            self.isLoggingOut = false
//                    //                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
//                    //
//                    //                        }
//                    
//                    
//                
//            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.inline)
//            
//            
////
////                        SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!).onAppear(){
////                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
////                            self.token = ""
////                            self.isLoggingOut = false
////                        }
//////                        .scaleEffect(0.01).offset(CGSize(width: 100.0, height: 100.0))
////                    
////                    
////                    
////                    //                        .onAppear(){
////                    //                            self.token = nil
////                    //                            self.isLoggingOut = false
////                    //                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
////                    //
////                    //                        }
////                    
////                    
////                
////            }
////            .navigationTitle("Profile")
////            .navigationBarTitleDisplayMode(.inline)
//            //                    .navigate(using: $shouldNavigateToContentView, destination: type(of: LionLinkApp()).init)
//        }
//        AuthView().isVisible(isLoggingOut)
//    }
//    
//    // MARK: - Networking
//    func fetchUserProfile() {
//        guard let url = URL(string: "\(APIConstants.baseURL)/auth/user") else {
//            print("Invalid URL for user profile.")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Network error occurred: \(error)")
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
//                print("HTTP Error: \(httpResponse.statusCode)")
//                return
//            }
//            guard let data = data else {
//                print("No data received.")
//                return
//            }
//            
//            // Print the raw data as a string
//            if let rawResponseString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n\(rawResponseString)")
//            }
//            
//            do {
//                let decodedUser = try JSONDecoder().decode(UserProfile.self, from: data)
//                DispatchQueue.main.async {
//                    self.user = decodedUser
//                    if let picture = decodedUser.picture, let url = URL(string: picture) {
//                        self.loadProfileImage(from: url)
//                    } else {
//                        self.profileImage = Image(systemName: "person.crop.circle.badge.plus")
//                    }
//                }
//            } catch {
//                print("JSON decoding error: \(error)")
//            }
//        }.resume()
//    }
//    func delUserProfile(userId:Int) {
//        guard let url = URL(string: "\(APIConstants.baseURL)/auth/user/\(userId)") else {
//            print("Invalid URL for user profile.")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Network error occurred: \(error)")
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
//                print("HTTP Error: \(httpResponse.statusCode)")
//                return
//            }
//            guard let data = data else {
//                print("No data received.")
//                return
//            }
//            
//            // Print the raw data as a string
//            if let rawResponseString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n\(rawResponseString)")
//            }
//            
//            do {
//                let decodedUser = try JSONDecoder().decode(UserProfile.self, from: data)
//                DispatchQueue.main.async {
//                    self.user = decodedUser
//                    if let picture = decodedUser.picture, let url = URL(string: picture) {
//                        self.loadProfileImage(from: url)
//                    } else {
//                        self.profileImage = Image(systemName: "person.crop.circle.badge.plus")
//                    }
//                }
//            } catch {
//                print("JSON decoding error: \(error)")
//            }
//        }.resume()
//    }
//
//    func loadProfileImage(from url: URL) {
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = Image(uiImage: uiImage)
//                }
//            }
//        }.resume()
//    }
//    
//    func uploadImage() {
//        guard let inputImage = inputUIImage else { return }
//            
//        profileImage = Image(uiImage: inputImage)
//            
//        uploadProfilePicture(image: inputImage)
//    }
//    func deleteImage() {
//        profileImage = Image(systemName: "person.crop.circle.badge.plus")
//        let uiImage = profileImage.asUIImage()
//        uploadProfilePicture(image: uiImage)
//        
//    }
//        
//        func uploadProfilePicture(image: UIImage) {
//            guard let url = URL(string: "\(APIConstants.baseURL)/user/photo") else { return }
//                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//                
//                var request = URLRequest(url: url)
//                request.httpMethod = "PUT"
//                request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
//                
//                let boundary = "Boundary-\(UUID().uuidString)"
//                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//                
//                var body = Data()
//                body.append("--\(boundary)\r\n".data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
//                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//                body.append(imageData)
//                body.append("\r\n".data(using: .utf8)!)
//                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//                
//                request.httpBody = body
//                
//                URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Upload error: \(error)")
//                    return
//                }
//                guard let response = response as? HTTPURLResponse,
//                      (200...299).contains(response.statusCode) else {
//                    print("Server error: \(String(describing: response))")
//                    return
//                }
//                
//                
//                    DispatchQueue.main.async {
//                                
//                                self.inputUIImage = nil
//                                
//                                if let mimeType = response.mimeType, mimeType == "application/json", let data = data {
//                                    do {
//                                        let updatedUser = try JSONDecoder().decode(UserProfile.self, from: data)
//                                        self.user = updatedUser
//                                    } catch {
//                                        print("JSON update decoding error: \(error)")
//                                    }
//                                }
//                            }
//            }.resume()
//        }
////    func DeleteAcc(userID: String) {
////                                guard let url = URL(string: "\(APIConstants.baseURL)/user/\(userID)") else { return }
////            
////            var request = URLRequest(url: url)
////            request.httpMethod = "DELETE"
////            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
////            
////           
////            
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            
//////            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
//////                print("error: \(error)")
//////                return
//////            }
////            if let error = error {
////                print("Upload error: \(error)")
////                return
////            }
////            guard let response = response as? HTTPURLResponse,
////                  (200...299).contains(response.statusCode) else {
////                print("Server error: \(String(describing: response))")
////                return
////            }
////            
////            
////               
////        }.resume()
////    }
//    func DeleteAcc(userId: Int?) {
//        guard let url = URL(string: "\(APIConstants.baseURL)/user/\(userId ?? 1)") else {
//            print("didn't work")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print(error?.localizedDescription ?? "error")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("Invalid response")
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                print("worked")
//            } else {
//                let message = String(data: data ?? Data(), encoding: .utf8)
//                print(message)
//            }
//        }
//
//        task.resume()
//    }
//    func deleteUserAccount(userId: Int, token: String) {
////        completion: @escaping (Result<String, Error>) -> Void
//        // Define the URL
//        guard let url = URL(string: "\(APIConstants.baseURL)/user/:\(userId)") else {
////            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
//            return
//        }
//        
//        // Create the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add authorization token if required
//        
//        // Make the request
////        let task = URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                completion(.failure(error))
////                return
////            }
////            
////            guard let httpResponse = response as? HTTPURLResponse else {
////                completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
////                return
////            }
////            
////            switch httpResponse.statusCode {
////            case 200:
////                completion(.success("Account successfully deleted."))
////            case 404:
////                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
////            case 403:
////                completion(.failure(NSError(domain: "Not authorized to delete this account", code: 403, userInfo: nil)))
////            default:
////                completion(.failure(NSError(domain: "Unexpected server error", code: httpResponse.statusCode, userInfo: nil)))
////            }
////        }
////        
////        task.resume()
//    }
//
//    func updateProfileImage(from url: URL) {
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = Image(uiImage: uiImage)
//                    self.inputUIImage = uiImage
//                }
//            }
//        }.resume()
//        DispatchQueue.main.async {
//            self.inputUIImage = nil
//        }
//    }
//}
//
//// MARK: - Models
//struct UserProfile: Codable {
//    let id: Int
//    let firstName, lastName, nickName: String
//    let gradYear: Int
//    let email: String
//    let googleId: String
//    let roleId: Int
//    let picture: String?
//    let role: UserRole
//
//    enum CodingKeys: String, CodingKey {
//        case id, firstName, lastName, nickName = "nickName", gradYear, email, googleId, roleId, picture, role
//    }
//}
//
//struct UserRole: Codable {
//    let id: Int
//    let name: String
//    let permissions: [RolePermission]
//}
//
//struct RolePermission: Codable {
//    let roleId: Int
//    let permissionId: Int
//    let role: PermissionRole
//    let permission: Permission
//}
//
//struct PermissionRole: Codable {
//    let id: Int
//    let name: String
//}
//
//struct Permission: Codable {
//    let id: Int
//    let name: String
//    let key: String
//}
//
//
//// MARK: - Image Picker
//struct ImagePickers: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(image: $image)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        @Binding var image: UIImage?
//
//        init(image: Binding<UIImage?>) {
//            _image = image
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                image = uiImage
//            }
//            picker.dismiss(animated: true)
//        }
//    }
//    
//}
//extension View {
//// This function changes our View to UIView, then calls another function
//// to convert the newly-made UIView to a UIImage.
//    public func asUIImage() -> UIImage {
//        let controller = UIHostingController(rootView: self)
//        
// // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
//        controller.view.backgroundColor = .clear
//        
//        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
//        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
//        
//        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
//        controller.view.bounds = CGRect(origin: .zero, size: size)
//        controller.view.sizeToFit()
//        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
//        let image = controller.view.asUIImage()
//        controller.view.removeFromSuperview()
//        return image
//    }
//}
//
//extension UIView {
//// This is the function to convert UIView to UIImage
//    public func asUIImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
//}
//

import SwiftUI

struct Profile: View {
    @AppStorage("token") var token: String?
    @AppStorage("id") var id: String?
    @State private var user: UserProfile?
    @State private var showingImagePicker = false
    @State private var profileImage: Image?
    @State private var inputUIImage: UIImage?
    @State private var isLoggingOut = false
    @State private var shouldNavigateToContentView = false
    @State private var isDeletingAccount = false
    @State private var showingAlert = false
    @StateObject var viewModel = SafariViewModel()
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                Spacer()
                // Profile Image
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 10)
                        .padding(.top, 100)
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                }
                
                // User Information
                if let user = user {
                    Text("Welcome \(user.nickName)")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 10)
                    VStack(spacing: 5) {
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.system(size: 18, weight: .regular))
                        Text(user.email)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text("Class of \(String(user.gradYear))")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    // Upload Photo Button
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Text("Upload New Photo")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 40)
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            self.fetchUserProfile()
                        }
                }
                
                VStack(spacing: 16) {
                    Button(action: {
                        // Logout action
                        self.isLoggingOut = true
                    }) {
                        Text("Logout")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                            .padding(.horizontal, 40)
                    }
                    // Privacy Policy Button
                    Button(action: {
                        if let url = URL(string: "https://hub-dev.stmarksschool.org/privacy-policy") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    //Delete Acc button
                    Button(action: {
                        //Delete account action
                        //self.isLoggingOut = true
                        showingAlert = true
                    }) {
                        Text("Delete Account")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 100)
                    .isVisible(!(user?.email.contains("@stmarksschool.org") ?? true))
                }
            }
            .padding()
            .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
                ImagePickers(image: self.$inputUIImage)
            }
            .alert(isPresented:$showingAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure want to delete your account? This will permanently erase your account."),
                    primaryButton: .destructive(Text("Delete")) {

                        self.isDeletingAccount = true
                        showingAlert = false
//                        print("\(user?.id ?? 00)")
////                            self.delUserProfile(userId: 8398702)
//                        DeleteAcc(userId: user?.id)
//                        print("\(user?.id ?? 00)")
//                        self.isLoggingOut = true
//                        self.token = ""
                        
                    },
                    secondaryButton: .cancel()
                )
            }
            .fullScreenCover(isPresented: $isLoggingOut) {
                
                    
                        SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!).onAppear(){
                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.token = ""
                                self.isLoggingOut = false
                            }
                            
                        }
//                        .scaleEffect(0.01).offset(CGSize(width: 100.0, height: 100.0))
                    
                    
                    
                    //                        .onAppear(){
                    //                            self.token = nil
                    //                            self.isLoggingOut = false
                    //                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
                    //
                    //                        }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            //                    .navigate(using: $shouldNavigateToContentView, destination: type(of: LionLinkApp()).init)
        
        .fullScreenCover(isPresented: $isDeletingAccount) {
                
                    
                        SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!)
                        .task{
//                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
                            await DeleteAccAcc()
                            
                        }
//                        .scaleEffect(0.01).offset(CGSize(width: 100.0, height: 100.0))
                    
                    
                    
                    //                        .onAppear(){
                    //                            self.token = nil
                    //                            self.isLoggingOut = false
                    //                            self.shouldNavigateToContentView = true // Trigger navigation to ContentView
                    //
                    //                        }
                    
                    
                
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
        AuthView().isVisible(isLoggingOut)
    }
    
    // MARK: - Networking
    func fetchUserProfile() {
        guard let url = URL(string: "\(APIConstants.baseURL)/auth/user") else {
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
    func DeleteAccAcc() async{
//        print("\(user?.id ?? 00)")
//                            self.delUserProfile(userId: 8398702)
        print("I RAN")
        self.DeleteAcc(userId: user?.id)
//        print(token)
//        print("\(user?.id ?? 00)")
        self.token = ""
        self.isDeletingAccount = false
    }
    func DeleteAcc(userId: Int?) {
        guard let url = URL(string: "\(APIConstants.baseURL)/user/\(userId ?? 1)") else {
            print("didn't work")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                print("1st thing")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")

                return
            }

            if httpResponse.statusCode == 200 {
                print("worked")
                
            } else {
                let message = String(data: data ?? Data(), encoding: .utf8)
                print(message)
                return
            }
        }
        print("resuming")
        task.resume()
    }

    func uploadImage() {
        guard let inputImage = inputUIImage else { return }
            
        profileImage = Image(uiImage: inputImage)
            
        uploadProfilePicture(image: inputImage)
    }
        
        func uploadProfilePicture(image: UIImage) {
            guard let url = URL(string: "\(APIConstants.baseURL)/user/photo") else { return }
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

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}

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
extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

