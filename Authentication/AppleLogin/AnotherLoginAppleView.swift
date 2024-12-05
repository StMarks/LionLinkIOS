//
//  AnotherLoginAppleView.swift
//  LionLink
//
//  Created by Liam Bean on 12/3/24.
//

import SwiftUI

import SwiftUI
import AuthenticationServices

struct AnotherLoginAppleView: View {

    var body: some View {

        SignInWithAppleButton(.signUp) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                handleSuccessfulLogin(with: authorization)
            case .failure(let error):
                handleLoginError(with: error)
            }
        }
        .frame(height: 50)
        .padding()
        
    }
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(userCredential.user)
            
            if userCredential.authorizedScopes.contains(.fullName) {
                print(userCredential.fullName?.givenName ?? "No given name")
            }
            
            if userCredential.authorizedScopes.contains(.email) {
                print(userCredential.email ?? "No email")
            }
        }
    }
    
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \\(error.localizedDescription)")
    }
}

#Preview {
    AnotherLoginAppleView()
}
