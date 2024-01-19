import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL 

    // This function tells SwiftUI which UIKit view controller to instantiate for this view
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url) // Initialize the SFSafariViewController with the provided URL
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
