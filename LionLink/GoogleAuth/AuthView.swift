import SwiftUI


struct AuthView: View {
    @State private var showSafari = false // show the safar view or not
    let authURL: URL? = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/google") // Cool url that we have now
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("token") var token: String?
    
    var body: some View {
        if colorScheme == .dark {
            VStack {
                
                //basic UI stuff
                Image("lion")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
                Text("Lion Link")
                    .font(Font.custom("Baskerville-Bold", size: 39))
                    .foregroundColor(.white.opacity(0.80))

                Button(action: {
                    self.showSafari = true // pressed to show the safari view
                }) {
                    HStack {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                .sheet(isPresented: $showSafari) {
                    if let authURL = authURL {
                        SafariView(url: authURL)
                    }
                }
            }.onOpenURL { url in
                handleURL(url)
            }
        } else {
            //Below is just the light mode coloring everything else is the same
            VStack {
                Image("lion")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
                Text("Lion Link")
                    .font(Font.custom("Baskerville-Bold", size: 39))
                    .foregroundColor(.black.opacity(0.80))
                
                Button(action: {
                    self.showSafari = true
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
                
                .sheet(isPresented: $showSafari) {
                    if let authURL = authURL {
                        SafariView(url: authURL)
                    }
                }
            }.onOpenURL { url in
                handleURL(url)
            }
        }
    }
    
    
    
    func handleURL(_ url: URL) {

        guard url.scheme == "lionlink" else { return }
        // Convert the URL into URLComponents to parse the parts
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              // Look for the query item in the url named "token" and get the value of it
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return
        }

        // Store the token the goat(me) got :)
        self.token = token
        UserDefaults.standard.set(token, forKey: "token")
        
    }
}
