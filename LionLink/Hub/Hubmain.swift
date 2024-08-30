import SwiftUI

struct Hubmain: View {
    //main navigation page for the user "HUB" of information and places to navigate
    @AppStorage("token") var token: String?
    @Environment(\.colorScheme) var colorScheme
    @State private var user: UserProfile?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Maybe have nickname instead for international students? Ask class the opinion
                Text("Welcome \(user?.firstName ?? "")!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack(spacing: 20) {
                    Activity(text: "Calendar", iconName: "calendar", destination: AnyView(CalendarView().navigationBarBackButtonHidden(true)), active: false)
                    Activity(text: "009", iconName: "bolt.horizontal", destination: AnyView(PlayerView(gameService: GameService(token: token!)).navigationBarBackButtonHidden(false)), active: false)
                }
                
                HStack(spacing: 20) {
                    Activity(text: "Lunch Menu", iconName: "fork.knife", destination: AnyView(LunchMainView(lunchService: LunchService(token: token!)).navigationBarBackButtonHidden(false)), active: false)
                    Activity(text: "Sports", subtext: "(Coming Soon)", iconName: "football", destination: AnyView(TeamPgMain().navigationBarBackButtonHidden(false)), active: false)
                }
                HStack(spacing: 20) {
                    Activity(text: "Clubs", subtext: "(Coming Soon)", iconName: "graduationcap", destination: AnyView(Clubmain().navigationBarBackButtonHidden(true)), active: false)
                    Activity(text: "Lost & Found", subtext: "(Coming Soon)", iconName: "vial.viewfinder", destination: AnyView(Lostmain().navigationBarBackButtonHidden(false)), active: false)
                }
                //A Stack of Activities only meant for those with superadmin.
                HStack(spacing: 20) {
                    if user?.role.name == "superadmin" {
                        Activity(text: "Admin Club", iconName: "tray", destination: AnyView(Clubmainthesecond().navigationBarBackButtonHidden(false)), active: false)
                        Activity(text: "009 Admin", iconName: "bolt.horizontal", destination: AnyView(doubleooNineAdmin().navigationBarBackButtonHidden(false)), active: false)
                    }
                }
            }
            .padding()
            .navigationBarTitle("Lion Link", displayMode: .inline)
            .onAppear {
                fetchUserProfile()
            }
        }
    }
    
    
    
    // MARK: - Basic User Data
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
            
            // Print Statement to check it's getting the data
//            if let rawResponseString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n\(rawResponseString)")
//            }
            
            do {
                let decodedUser = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.user = decodedUser
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }
}
