import SwiftUI

import AuthenticationServices

struct AuthView: View {
    @State private var showSafari = false // show the safari view or not
    let authURL: URL? = URL(string: "\(APIConstants.baseURL)/auth/google") // Cool url that we have now
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("token") var token: String?
    @AppStorage("id") var id: Int?
    @StateObject private var viewModel = SafariViewModel()
    @State var randCat = MockData.cats.randomElement() ?? MockData.sampleCat
    var body: some View {
        NavigationView{
//            if colorScheme == .light { //lightmode
//                
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
                            .foregroundColor(.whiteNBlack)
                        
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
                        
                        //Privacy Policy
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
                        Button(
                        action:{
                            self.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzSW4iOiIzZCIsImlkIjozNDY2MjUzLCJlbWFpbCI6Imxpb25saW5rdGVzdEBnbWFpbC5jb20iLCJpYXQiOjE3MzkyOTU4ODB9.P9CyAcuh1AZ-4LRk3-cCRYLGzWNdKLxk6iR8IKibhq4"// WALTER
//                            self.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzSW4iOiIzZCIsImlkIjo1MTQxMzU1LCJlbWFpbCI6Im1hdHRoZXdmZXJuYW5kZXpAc3RtYXJrc3NjaG9vbC5vcmciLCJpYXQiOjE3NDA1MDI4MzB9.QFzBjv8ozOnbmjOIL_6_otAHwFqOBVp_y1xHNFnnURc" //MATTHEW
                        }, label: {
                            Text("DemoMode")
                        })
                    }
                    .onOpenURL { url in
                        handleURL(url)
                        
                        
                    }
                   
                }
//            }
//                else{ //darkmode
//                    ZStack{
//                        VStack(spacing: 20) {
//                                    Spacer()
//                            
//                            //lionlink logo
//                            Image("lion")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 100, height: 100)
//                                //.padding()
//                            
//                            //title
//                            Text("Lion Link")
//                                .font(.system(size: 30, weight: .bold))
//                                .foregroundColor(.whiteNBlack)
//                            
//                            //sign in with google button
//                            Button(action: {
//                                self.showSafari = true //pressed to show the safari view
//                            }) {
//                                HStack {
//                                    Image("google")
//                                        .resizable()
//                                        .frame(width: 18, height: 18)
//                                    Text("Sign in with Google")
//                                        .font(.system(size: 20, weight: .semibold))}
//                                .padding()
//                                .frame(maxWidth: .infinity, maxHeight: 50)
//                                .background(Color.white)
//                                .foregroundColor(.black)
//                                .cornerRadius(8)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color.gray, lineWidth: 1)
//                                )
//                            }
//                            .padding(.horizontal, 40)
//                            
//                            .sheet(isPresented: $showSafari) {
//                                if let authURL = authURL {
//                                    SafariView(viewModel: viewModel, url: authURL)
//                                }
//                            }
//                            
//                            // Sign in with Apple Button (Button UI is in AppleLog(); SignInWithAppleButton is a system-provided UI component)
//                            AppleLog()
//                            
//                            //Privacy Policy
//                            VStack {
//                                Text("By clicking Sign in, you accept Lion Link's ")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.gray)
//                                    .multilineTextAlignment(.center)
//                                HStack(spacing: 0) {
//                                    Text("Privacy Policy")
//                                        .font(.system(size: 12, weight: .bold))
//                                        .foregroundColor(.blue)
//                                        .underline()
//                                        .onTapGesture {
//                                            if let url = URL(string: "https://hub-dev.stmarksschool.org/privacy-policy") {
//                                                UIApplication.shared.open(url)
//                                            }
//                                        }
//                                }
//                            }
//                            .padding(.horizontal, 40)
//                            .padding(.bottom, 250)
//                            Button(
//                            action:{
////                                self.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzSW4iOiIzZCIsImlkIjozNDY2MjUzLCJlbWFpbCI6Imxpb25saW5rdGVzdEBnbWFpbC5jb20iLCJpYXQiOjE3MzkyOTU4ODB9.P9CyAcuh1AZ-4LRk3-cCRYLGzWNdKLxk6iR8IKibhq4"
//                                self.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzSW4iOiIzZCIsImlkIjo1MTQxMzU1LCJlbWFpbCI6Im1hdHRoZXdmZXJuYW5kZXpAc3RtYXJrc3NjaG9vbC5vcmciLCJpYXQiOjE3NDA1MDI4MzB9.QFzBjv8ozOnbmjOIL_6_otAHwFqOBVp_y1xHNFnnURc" //MATTHEW
//                            }, label: {
//                                Text("DemoMode")
//                            })
//
//                        }.onOpenURL { url in
//                            handleURL(url)
//                            
//                        }
//                    }
//                }
            
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
//            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//                  // Look for the query item in the url named "token" and get the value of it
//                  let id = components.queryItems?.first(where: { $0.name == "id" })?.value else {
//                    return
//                }
                
            
            
            // Store the token the goat(me) got :)
            self.token = token
//            self.id = Int(id)
            UserDefaults.standard.set(token, forKey: "token")
            print("\(token)")
            
        }
    
    
}
