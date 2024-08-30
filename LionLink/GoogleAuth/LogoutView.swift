import SwiftUI

struct LogoutView: View {
    let onLoggedOut: () -> Void

    var body: some View {
        VStack {
            Text("Logging out...")
            SafariView(url: URL(string: "https://accounts.google.com/Logout")!)
            
        }
    }
}
