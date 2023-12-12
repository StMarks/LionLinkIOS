import SwiftUI

struct Hubmain: View {
    
    @AppStorage("token") var token: String?
    
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Activity(text: "Calendar", iconName: "calendar", destination: AnyView(CalendarView().navigationBarBackButtonHidden(true)))
                        Activity(text: "Club", iconName: "basketball.text", destination: AnyView(Clubmain().navigationBarBackButtonHidden(false)))
                    }
                    Activity(text: "Sports", iconName: "hand.raised", destination: AnyView(TeamPgMain().navigationBarBackButtonHidden(false)))
                }
                .padding()
                .navigationBarTitle("Lion Link", displayMode: .inline)
            }
        }
}

