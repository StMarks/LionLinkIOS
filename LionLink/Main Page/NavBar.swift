import SwiftUI

struct NavBar: View {
    let month: String
    
    var body: some View {
        HStack {
            Image(systemName: "cat.fill") // Replace with your desired image.
                .resizable()
                .frame(width: 30, height: 30)
            
//            Spacer()
            
            Text(month)
                .font(.title)
                .bold()
            
            Spacer()
            
            Image(systemName: "person.fill") // Replace with your desired image.
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        }
        .padding()
    }
}
