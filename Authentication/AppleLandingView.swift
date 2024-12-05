//
//  AppleLandingView.swift
//  LionLink
//
//  Created by Jayden Yoon on 12/4/24.
//

import SwiftUI

struct AppleLandingView: View {
    @State var randCat = MockData.cats.randomElement() ?? MockData.sampleCat
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    private var isSignedIn: Bool{
        !userId.isEmpty
    }
    private func RandomizeCat(){
        self.randCat = MockData.cats.randomElement() ?? MockData.sampleCat
        
    }
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Heading
            Text("Uh Oh!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 10)

            // Subheading
            Text("It seems like you don’t have a St. Mark’s organization account.")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Body Text
            Text("Lion Link is exclusively available to students and faculty of St. Mark’s School. To access the platform, you need to log in with a @stmarksschool.org email address.")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                //.padding(.bottom, 20)

            // Additional Information
            Text("If you’re not currently a part of St. Mark’s School but are interested in joining our community, consider exploring opportunities to become a student.")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            //Spacer()

            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    self.userId = ""
                    self.email = ""
                    self.firstName = ""
                    self.lastName = ""
                }) {
                    Text("Delete Account")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }

                Button(action: {
                    // Open St. Mark's admissions page
                    if let url = URL(string: "https://www.stmarksschool.org/admission") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Apply to St. Mark's")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
            }

            //Spacer()

            // Support Link
            VStack {
                Text("Need help? Contact us at")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Text("helpdesk@stmarksschool.org")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        if let url = URL(string: "mailto:helpdesk@stmarksschool.org") {
                            UIApplication.shared.open(url)
                        }
                    }
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AppleLandingView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLandingView()
    }
}

//struct AppleLandingView: View {
//    @State var randCat = MockData.cats.randomElement() ?? MockData.sampleCat
//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""
//    private var isSignedIn: Bool{
//        !userId.isEmpty
//    }
//    private func RandomizeCat(){
//        self.randCat = MockData.cats.randomElement() ?? MockData.sampleCat
//        
//    }
//    var body: some View {
//    
//        ScrollView{
//            ZStack(alignment:.top) {
////                Image("lion")
////                    .resizable()
////                    .scaledToFit()
////                    .blur(radius:40)
////                    .padding(.top,200)
//                VStack{
//                    Text("Uh Oh! It seems that you don't have a St. Mark's email account!")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding()
//                    
//                    Text("Why St. Mark’s? An investment in a St. Mark’s education is an investment in your student's future. St. Mark’s School educates young people for lives of leadership and service. Founded in 1865 as an intentionally small residential community, the School challenges its students to develop their particular analytic and creative capabilities by both inspiring their academic and spiritual curiosity and kindling their passion for discovery. We value cooperation over self-interest, and we encourage each person to explore their place in the larger world beyond our campus.")
//                        .font(.system(size:30))
//                        .padding(20)
//                        
//                    Button{
//                        self.userId = ""
//                        self.email = ""
//                        self.firstName = ""
//                        self.lastName = ""
//                    }label:{
//                        Text("Delete Account")
//                            .frame(width:250,height:70)
//                            .background(.blue)
//                            .font(.system(size:30))
//                            .foregroundStyle(.white)
//                            .bold()
//                            .clipShape(RoundedRectangle(cornerSize: CGSize(width:10, height: 10)))
//                            .padding()
//                    }
//                        Spacer()
////                        ForEach(0..<100) {number in
////                            Image(MockData.cats.randomElement()?.imageName ?? MockData.sampleCat.imageName)
////                                .resizable()
////                                .scaledToFit()
////                        }
//                    }
//                }
//            }
//            .scrollTransition(.interactive){content, phase in
//                content
//                    .opacity(phase.isIdentity ?1:0.9)
//                
//            }
//        
//    }
//}

//#Preview {
//    AppleLandingView(email: "wef", firstName: "13", lastName: "12", userId: "1")
//}
