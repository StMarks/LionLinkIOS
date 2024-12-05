//
//  AppleLoginView.swift
//  LionLink
//
//  Created by Liam Bean on 12/3/24.
//
//
//import SwiftUI
//import AuthenticationServices
//
//struct AppleLoginView: View {
//    var window: UIWindow?
//    let appleIDProvider = ASAuthorizationAppleIDProvider()
//    var body: some View {
//        onAppear(){
//            application(application: UIApplication, didFinishLaunchingWithOptions, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
//        }
//    }
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
//            default:
//                break
//            }
//        }
//        return true
//    }
//}
//
//
///// - Tag: did_finish_launching
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    let appleIDProvider = ASAuthorizationAppleIDProvider()
//    appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//        switch credentialState {
//        case .authorized:
//            break // The Apple ID credential is valid.
//        case .revoked, .notFound:
//            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//            DispatchQueue.main.async {
//                self.window?.rootViewController?.showLoginViewController()
//            }
//        default:
//            break
//        }
//    }
//    return true
//}
//
//#Preview {
//    AppleLoginView()
//}
//class LoginViewController: UIViewController {
//    
//    @IBOutlet weak var loginProviderStackView: UIStackView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupProviderLoginView()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        performExistingAccountSetupFlows()
//    }
//    
//    /// - Tag: add_appleid_button
//    func setupProviderLoginView() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//        self.loginProviderStackView.addArrangedSubview(authorizationButton)
//    }
//    
//    // - Tag: perform_appleid_password_request
//    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//        
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//    
//    /// - Tag: perform_appleid_request
//    @objc
//    func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//}
//
//extension LoginViewController: ASAuthorizationControllerDelegate {
//    /// - Tag: did_complete_authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
//            
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//        
//        case let passwordCredential as ASPasswordCredential:
//        
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//            
//        default:
//            break
//        }
//    }
//    
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
//    
//    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? ResultViewController
//            else { return }
//        
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    private func showPasswordCredentialAlert(username: String, password: String) {
//        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//        let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                message: message,
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    /// - Tag: did_complete_error
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//    }
//}
//
//extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
//    /// - Tag: provide_presentation_anchor
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
//
//extension UIViewController {
//    
//    func showLoginViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
//            loginViewController.modalPresentationStyle = .formSheet
//            loginViewController.isModalInPresentation = true
//            self.present(loginViewController, animated: true, completion: nil)
//        }
//    }
//}
