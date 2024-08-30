import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL 

    // tells Swift which UIKit view controller to instantiate 
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
