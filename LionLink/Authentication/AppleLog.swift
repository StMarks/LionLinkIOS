//
//  AppleLog.swift
//  LionLink
//
//  Created by Liam Bean on 12/4/24.
//

import SwiftUI
import AuthenticationServices
struct AppleLog: View {
    @Environment(\.colorScheme) var colorScheme

    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    
    private var isSignedIn: Bool{
        !userId.isEmpty
    }
    var body: some View {
        
        
                
                if !isSignedIn{
                    AppleInButtonView()
                }
                else{
                    //DummyPageMainView()
                    AppleLandingView()
                }
                
        
    }
}

struct AppleInButtonView: View{
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        SignInWithAppleButton(.signIn){request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result{
            case.success(let auth):
                switch auth.credential{
                case let credential as ASAuthorizationAppleIDCredential:
                    //User Id
                    let userId = credential.user
                    
                    //User Information
                    let email = credential.email
                    let firstName = credential.fullName?.givenName
                    let lastName = credential.fullName?.familyName
                    
                    self.email = email ?? ""
                    self.userId = userId
                    self.firstName = firstName ?? ""
                    self.lastName = lastName ?? ""
                    
                default:
                    break
                }
            case.failure(let error):
                print(error)
            }
        }
//        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
//        .frame(width:200, height:50)
//        .padding()
//        .cornerRadius(8)
        //JY-i changed so it matches with sign in with google button in AuthView
        .signInWithAppleButtonStyle(.black) // Ensures the button style is consistent
        .frame(maxWidth: .infinity, maxHeight: 50) // Matches the height of the Google button
        .cornerRadius(8) // Rounded corners to match the Google button
        .padding(.horizontal, 40) // Consistent padding
    }
}


#Preview {
    AppleLog()
}
