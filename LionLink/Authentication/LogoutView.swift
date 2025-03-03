import SwiftUI

struct LogoutView: View {
    let onLoggedOut: () -> Void
    @StateObject var viewModel = SafariViewModel()
    var body: some View {
        VStack {
            SafariView(viewModel: viewModel, url: URL(string: "https://accounts.google.com/Logout")!)
        }
    }
}
