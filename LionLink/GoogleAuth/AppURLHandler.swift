import SwiftUI

struct AppURLHandler: View {
    // temporarily store the token after it's extracted from the URL
    @State private var token: String? = nil
    
    // The openURL environment variable is used to interact with URLs, allowing you to open or process them
    @Environment(\.openURL) var openURL

    var body: some View {
        // The main ContentView is wrapped inside a NavigationView for potential navigation actions
        NavigationView {
            ContentView()
        }
        // Listens for an "open URL" event, which will call the handleURL function when a URL is opened
        .onOpenURL { url in
            handleURL(url)
        }
    }

    // This function processes the URL to extract and store the token
    func handleURL(_ url: URL) {
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
