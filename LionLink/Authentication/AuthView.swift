import SwiftUI

import AuthenticationServices

struct AuthView: View {
    @State private var showSafari = false // show the safari view or not
    let authURL: URL? = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/google") // Cool url that we have now
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("token") var token: String?
    @StateObject private var viewModel = SafariViewModel()
    @State var randCat = MockData.cats.randomElement() ?? MockData.sampleCat
    var body: some View {
        NavigationView{
            if colorScheme == .light { //lightmode
                ZStack{
                    VStack(spacing: 20) {
                                Spacer()
                        
                        //lionlink logo
                        Image("lion")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            //.padding()
                        
                        //title
                        Text("Lion Link")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        
                        //sign in with google button
                        Button(action: {
                            self.showSafari = true //pressed to show the safari view
                        }) {
                            HStack {
                                Image("google")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                Text("Sign in with Google")
                                    .font(.system(size: 20, weight: .semibold))}
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 40)
                        
                        .sheet(isPresented: $showSafari) {
                            if let authURL = authURL {
                                SafariView(viewModel: viewModel, url: authURL)
                            }
                        }
                        
                        // Sign in with Apple Button (Button UI is in AppleLog(); SignInWithAppleButton is a system-provided UI component)
                        AppleLog()
                        // Privacy Policy Text
//                            Text("By clicking Sign in, you accept Lion Link's Privacy Policy")
//                                .font(.system(size: 12))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal, 40)
                        
                        VStack {
                            Text("By clicking Sign in, you accept Lion Link's ")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            HStack(spacing: 0) {
                                Text("Privacy Policy")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.blue)
                                    .underline()
                                    .onTapGesture {
                                        if let url = URL(string: "https://hub-dev.stmarksschool.org/privacy-policy") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 250)
                        
                        //Dummy by Liam
//                            NavigationLink("Dummy",destination:AnotherLoginAppleView().navigationBarBackButtonHidden(true))
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(.blue)
//                                .cornerRadius(10)
                        
                        
                    }
                    .onOpenURL { url in
                        handleURL(url)
                    }
                }
            }
                else{ //darkmode
                    ZStack{
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
                                    SafariView(viewModel: viewModel, url: authURL)
                                }
                            }
                            AppleLog()
                        }.onOpenURL { url in
                            handleURL(url)
                            
                        }
                    }
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
            print("\(token)")
            
        }
    
    
}
