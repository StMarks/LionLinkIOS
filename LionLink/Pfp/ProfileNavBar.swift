import SwiftUI

struct ProfileNavBar: View {
    let month: String
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: Hubmain().navigationBarBackButtonHidden(true),
                label: {
                    Image("lion")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            )
            
            Text(month)
                .font(.title)
                .bold()
                
            Spacer()
            
            
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .foregroundColor(.blue)
                
        }
        .padding()
    }
}


