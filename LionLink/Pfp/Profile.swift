import SwiftUI
import PhotosUI

struct Profile: View {
    @AppStorage("isDarkMode") public var isDarkMode: Bool = false
    @AppStorage("token") var token: String?
    @State private var centeredDate = Date()
//    @State private var showImagePicker = false
//    @State private var imagePickerSourceType = UIImagePickerController.SourceType.photoLibrary
//    @State private var profileImage: UIImage? = UIImage(systemName: "person.fill")
//    @State private var showActionSheet = false
//
//    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()
//
//    var body: some View {
        //
//        VStack {
//            if let profileImage = profileImage {
//                Image(uiImage: profileImage)
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                    .onTapGesture {
//                        showActionSheet = true
//                    }
//                    .actionSheet(isPresented: $showActionSheet) {
//                        ActionSheet(title: Text("Select Photo"), message: Text("Choose a photo source"), buttons: [
//                            .default(Text("Camera")) {
//                                self.imagePickerSourceType = .camera
//                                self.showImagePicker = true
//                            },
//                            .default(Text("Photo Library")) {
//                                self.imagePickerSourceType = .photoLibrary
//                                self.showImagePicker = true
//                            },
//                            .cancel()
//                        ])
//                    }
//            }
//            
            
//        }
//        .background(isDarkMode ? Color.black : Color.white)
//        .foregroundColor(isDarkMode ? Color.white : Color.black)
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(sourceType: imagePickerSourceType, selectedImage: $profileImage)
//        }
//    }
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
         
        var body: some View {
            NavBar(month: monthFormatter.string(from: centeredDate))

            NavigationView {
                VStack {
                    VStack {
                        ZStack(alignment: .top) {
                            Rectangle()
                                .foregroundColor(Color.blue)
                                .edgesIgnoringSafeArea(.top)
                                .frame(height: 100)
                             
                            Button {
                                shouldShowImagePicker.toggle()
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 143, height: 143)
                                            .cornerRadius(80)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 80))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 80)
                                            .stroke(Color.black, lineWidth: 3)
                                )
                            }
                        }//end Zstack
                    }
                     
                    VStack(spacing: 15) {
                        VStack(spacing: 5) {
                            Text(token ?? "fail")
                                .bold()
                                .font(.title)

                        }.padding()
                        
                    }
                    Spacer()
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .padding()
                    Spacer()
                    Button("Clear Token") {
                        token = nil
                    }
                    .padding(.horizontal)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
        }
}

struct ImagePicker: UIViewControllerRepresentable {
 
    @Binding var image: UIImage?
 
    private let controller = UIImagePickerController()
 
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
 
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
        let parent: ImagePicker
 
        init(parent: ImagePicker) {
            self.parent = parent
        }
 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
 
    }
 
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
 
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
 
    }
 
}
