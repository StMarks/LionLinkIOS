import SwiftUI

struct NavBar: View {
    let month: String
    
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: CalendarView().navigationBarBackButtonHidden(true),
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
