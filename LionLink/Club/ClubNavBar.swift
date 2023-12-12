import SwiftUI

struct ClubNavBar: View {
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
            
            
                
            Spacer()
            
            NavigationLink(
                destination: Profile().navigationBarBackButtonHidden(true),
                label: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                }
            )
        }
        .padding()
    }
}


