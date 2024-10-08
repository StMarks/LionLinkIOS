import SwiftUI

struct ContentView: View {
    @AppStorage("token") var token: String?
    
    //user needs a token for app check if has one
    var body: some View {
        if let token = token, !token.isEmpty {
            //if user has a token then send to main page
            Hubmain()
        } else {
            //if user does not have a token then send to them to autherize 
            AuthView()
        }
    }
}



