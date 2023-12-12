import SwiftUI
import PhotosUI

// MARK: - Club Model
class Club: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var coHeads: [String]
    @Published var membersCount: Int
    @Published var description: String
    @Published var image: UIImage?
    @Published var isJoined: Bool

    init(name: String, coHeads: [String], membersCount: Int, description: String, image: UIImage? = UIImage(named: "placeholder"), isJoined: Bool = false) {
        self.name = name
        self.coHeads = coHeads
        self.membersCount = membersCount
        self.description = description
        self.image = image
        self.isJoined = isJoined
    }
}

// MARK: - Club Data Observable Object
class ClubData: ObservableObject {
    @EnvironmentObject var clubData: ClubData
    @Published var clubs: [Club] = []
    @Published var searchText = ""

    var filteredClubs: [Club] {
        searchText.isEmpty ? clubs : clubs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    // Initializer with mock data for testing purposes
    init() {
        self.clubs = [
            // Assuming "codingClub" is a placeholder image name in your assets.
//            Club(name: "Coding Club", coHeads: ["Ian Choe", "Jane Doe"], membersCount: 365, description: "Cool Coders", image: UIImage(named: "codingClub")),
            // ... add more mock clubs as needed
        ]
    }
}

// MARK: - Image Picker Component
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image
                        }
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - ContentView
struct Clubmain: View {
    @StateObject var clubData = ClubData()
    @State private var showingAddClubView = false

    var body: some View {
        
        NavigationView {
            
            VStack {
                // Search bar at the top of the main view
                
                SearchBar(text: $clubData.searchText)
                    .padding()
                
                // Scrollable list of clubs
                ScrollView {
                    VStack {
                        ForEach(clubData.filteredClubs) { club in
                            NavigationLink(destination: ClubDetailView(club: club).environmentObject(clubData)) {
                                ClubRow(club: club).environmentObject(clubData)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            // Navigation bar items for adding a new club and viewing joined clubs
            .navigationBarItems(
                leading: NavigationLink(destination: MyClubsView().environmentObject(clubData)) {
                    Text("My Clubs")
                },
                trailing: Button(action: {
                    showingAddClubView = true
                }) {
                    Image(systemName: "plus")
                }
            )
            // Presenting the add club view
            .sheet(isPresented: $showingAddClubView) {
                AddClubView().environmentObject(clubData)
            }
        }
    }
}

struct ClubsHorizontalScrollView: View {
    @EnvironmentObject var clubData: ClubData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(clubData.clubs.filter { $0.isJoined }) { club in
                    ClubCardView(club: club)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ClubCardView: View {
    var club: Club

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: club.image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 200)
                .clipped()
                .cornerRadius(15)

            Text(club.name)
                .font(.headline)
                .lineLimit(1)

            Text("Co-heads: \(club.coHeads.joined(separator: ", "))")
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
        .frame(width: 150, height: 250)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// MARK: - SearchBar Component
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search", text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
    }
}

// MARK: - ClubRow Component
struct ClubRow: View {
    @ObservedObject var club: Club
    @EnvironmentObject var clubData: ClubData

    var body: some View {
        ZStack {
            // Club image background
            if let uiImage = club.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
            } else {
                // Fallback color for when there is no image
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 100)
                    .cornerRadius(10)
            }

            // Club details overlay
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(club.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Co-heads: \(club.coHeads.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding([.leading, .top, .bottom], 10)

                Spacer()

                // Join button
                Button(action: {
                    // Correctly toggling the 'isJoined' state of the selected club
                    if let index = clubData.clubs.firstIndex(where: { $0.id == club.id }) {
                        clubData.clubs[index].isJoined.toggle()
                    }
                }) {
                    Image(systemName: club.isJoined ? "checkmark" : "plus")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(club.isJoined ? Color.blue : Color.green)
                        .clipShape(Circle())
                }
                .padding(.trailing, 10)
            }
        }
        .frame(height: 100)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}



// MARK: - ClubDetailView Component
// ClubDetailView for showing the details of a selected club
struct ClubDetailView: View {
    @ObservedObject var club: Club
    @EnvironmentObject var clubData: ClubData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Image at the top of the detail view
                Image(uiImage: club.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()

                // VStack for the club's details
                VStack(alignment: .leading, spacing: 10) {
                    Text(club.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Co-heads: \(club.coHeads.joined(separator: ", "))")
                        .font(.headline)
                    
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                        Text("\(club.membersCount) members")
                            .font(.subheadline)
                    }
                    
                    Text("Description:")
                        .font(.headline)
                    Text(club.description)
                        .font(.body)
                }
                .padding()
                .background(Color.white)
                // Apply corner radius to top corners
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.top)
            
            // Join button at the bottom of the detail view
            Button(action: {
                club.isJoined.toggle()
            }) {
                Text(club.isJoined ? "Joined ✓" : "Join")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(club.isJoined ? Color.green : Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitle("Club Details", displayMode: .inline)
    }
}



// MARK: - AddClubView Component
struct AddClubView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var clubData: ClubData
    @State private var name: String = ""
    @State private var coHeads: String = ""
    @State private var description: String = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Club Details")) {
                    TextField("Name", text: $name)
                    TextField("Co-Heads", text: $coHeads)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Club Photo")) {
                    Button("Select Photo") {
                        showingImagePicker = true
                    }
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
                Section {
                    Button("Add Club") {
                        let newClub = Club(name: name, coHeads: coHeads.components(separatedBy: ", "), membersCount: 1, description: description, image: selectedImage)
                        clubData.clubs.append(newClub)
                        // Close the modal view after adding the club
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Club", displayMode: .inline)
            // Show the image picker sheet
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

// MARK: - MyClubsView Component
//struct MyClubsView: View {
//    @EnvironmentObject var clubData: ClubData
//
//    var body: some View {
//        List {
//            ForEach(clubData.clubs.filter { $0.isJoined }) { club in
//                NavigationLink(destination: ClubDetailView(club: club).environmentObject(clubData)) {
//                    ClubRow(club: club).environmentObject(clubData)
//                }
//            }
//        }
//        .navigationBarTitle("My Clubs", displayMode: .inline)
//    }
//}

struct MyClubsView: View {
    @EnvironmentObject var clubData: ClubData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(clubData.clubs.filter { $0.isJoined }) { club in
                    ClubCardView(club: club)
                }
            }
            .padding(.horizontal)
        }
    }
}
