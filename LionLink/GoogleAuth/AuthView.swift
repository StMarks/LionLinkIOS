import SwiftUI

struct AuthView: View {
    @State private var showSafari = false // A state variable that determines whether to show the SFSafariViewController
    let authURL: URL? = URL(string: "https://b408-2600-387-5-805-00-61.ngrok-free.app/v1/auth/google") // The URL for Google authentication
    @State private var token: String? = nil

    
    var body: some View {
        VStack {
            Button(action: {
                self.showSafari = true // Set the showSafari state variable to true when the button is tapped
            }) {
                Text("Authenticate with Google")
            }
            .sheet(isPresented: $showSafari) { // The .sheet modifier presents a modal view (our SFSafariViewController in this case) when showSafari is true
                if let authURL = authURL { // Safely unwrap the authURL
                    SafariView(url: authURL) // Present the SafariView with the Google authentication URL
                }
            }
        }.onOpenURL { url in
            handleURL(url)
            
        }
       

        // This function processes the URL to extract and store the token
        
    }
    
    func handleURL(_ url: URL) {
        print("heyyyyyyyyy")
        guard url.scheme == "lionlink" else { return }
        // Convert the URL into URLComponents to parse its parts
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              // Look for query item named "token" and get its value
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return
        }

        // Store the retrieved token in the token state variable and also in UserDefaults
        self.token = token
        UserDefaults.standard.set(token, forKey: "token")
        
    }
}


#Preview {
    AuthView()
}
