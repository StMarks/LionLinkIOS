import SwiftUI

struct AuthView: View {
    @State private var showSafari = false // A state variable that determines whether to show the SFSafariViewController
    let authURL: URL? = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/google") // The URL for Google authentication
   
    @State private var token: String?
    
    
    var body: some View {
        VStack {
            
            Image("lion")
                .font(.system(size: 120))
                .foregroundColor(.blue)
            Text("Lion Link")
                .font(Font.custom("Baskerville-Bold", size: 39))
                .foregroundColor(.black.opacity(0.80))
            
            Button(action: {
                self.showSafari = true // Set the showSafari state variable to true when the button is tapped
            }) {
                HStack {
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Sign in with Google")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 40)
                .background(Color.blue)
                .cornerRadius(10)
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
