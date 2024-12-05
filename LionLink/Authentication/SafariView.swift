import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: SafariViewModel
    let url: URL
    
    // tells Swift which UIKit view controller to instantiate
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
    
}
class SafariViewModel: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    @Published var shouldLogout = false
    func logout() {
        clearCookiesAndCache()
        shouldLogout = true }
    private func clearCookiesAndCache() {
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    func presentSafariViewController(on viewController: UIViewController) {
        let safariViewController = SFSafariViewController(url: URL(string: "https://example.com")!)
        safariViewController.delegate = self
        viewController.present(safariViewController, animated: true, completion: nil)
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
