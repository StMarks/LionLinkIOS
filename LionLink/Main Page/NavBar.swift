import SwiftUI

struct NavBar: View {
    let month: String
    @AppStorage("isDarkMode") public var isDarkMode: Bool?

    
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
//                    if let image = image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .clipShape(Circle())
//                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
//                    }
                }
            )
        }
        .padding()
    }
}
