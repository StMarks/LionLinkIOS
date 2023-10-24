import SwiftUI

struct AuthView: View {
    @State private var showSafari = false // A state variable that determines whether to show the SFSafariViewController
    let authURL: URL? = URL(string: "http://10.1.223.130:8080/v1/auth/google") // The URL for Google authentication

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
        }
    }
}


#Preview {
    AuthView()
}
