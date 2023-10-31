import SwiftUI

struct Profile: View {
    @AppStorage("isDarkMode") public var isDarkMode: Bool = false
    
    @State private var centeredDate = Date()
    
    // DateFormatter for displaying the month name.
    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()
    var body: some View {
        NavBar(month: monthFormatter.string(from: centeredDate))
        
        VStack {
            
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
            Spacer()
            NavigationLink(
                destination: SignInView().navigationBarBackButtonHidden(true), 
                label: {
                    Text("Sign Out")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            )
            .padding(.horizontal)
        }
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? Color.white : Color.black)

    }
}


