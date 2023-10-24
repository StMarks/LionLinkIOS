import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL // The URL that the SFSafariViewController will display

    // This function tells SwiftUI which UIKit view controller to instantiate for this view
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url) // Initialize the SFSafariViewController with the provided URL
    }

    // This function tells SwiftUI how to update the UIKit view controller when this view's state or properties change
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // In this case, there's nothing we need to update, so this is left empty.
    }
}
