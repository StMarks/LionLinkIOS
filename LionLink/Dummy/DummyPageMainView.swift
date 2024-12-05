//
//  DummyPageMainView.swift
//  LionLink
//
//  Created by Liam Bean on 11/19/24.
//

import SwiftUI

struct DummyPageMainView: View {
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
    
        ScrollView{
            ZStack(alignment:.top) {
//                Image("lion")
//                    .resizable()
//                    .scaledToFit()
//                    .blur(radius:40)
//                    .padding(.top,200)
                VStack{
                    Text("Uh Oh! It seems that you don't have a St. Mark's email account!")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    Text("Why St. Mark’s? An investment in a St. Mark’s education is an investment in your student's future. St. Mark’s School educates young people for lives of leadership and service. Founded in 1865 as an intentionally small residential community, the School challenges its students to develop their particular analytic and creative capabilities by both inspiring their academic and spiritual curiosity and kindling their passion for discovery. We value cooperation over self-interest, and we encourage each person to explore their place in the larger world beyond our campus.")
                        .font(.system(size:30))
                        .padding(20)
                        
                    Button{
                        self.userId = ""
                        self.email = ""
                        self.firstName = ""
                        self.lastName = ""
                    }label:{
                        Text("Delete Account")
                            .frame(width:250,height:70)
                            .background(.blue)
                            .font(.system(size:30))
                            .foregroundStyle(.white)
                            .bold()
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width:10, height: 10)))
                            .padding()
                    }
                        Spacer()
//                        ForEach(0..<100) {number in
//                            Image(MockData.cats.randomElement()?.imageName ?? MockData.sampleCat.imageName)
//                                .resizable()
//                                .scaledToFit()
//                        }
                    }
                }
            }
            .scrollTransition(.interactive){content, phase in
                content
                    .opacity(phase.isIdentity ?1:0.9)
                
            }
        
    }
}

#Preview {
    DummyPageMainView(email: "wef", firstName: "13", lastName: "12", userId: "1")
}
