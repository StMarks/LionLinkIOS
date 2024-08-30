import SwiftUI

//custom structure for the hub navigation UI looks for dark and light mode as well as disabled. 
struct Activity: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var subtext: String?
    var iconName: String
    var destination: AnyView
    var active: Bool

    var body: some View {
        if colorScheme == .dark {
            NavigationLink(destination: destination) {
                VStack {
                    Image(systemName: iconName)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Text(text)
                        .foregroundColor(.black)
                        .font(.headline)
                    if(subtext != nil){
                        Text(subtext!)
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                .frame(width: 150, height: 150)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            }
            .disabled(active)
            
        } else {
            NavigationLink(destination: destination) {
                VStack {
                    Image(systemName: iconName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text(text)
                        .foregroundColor(.white)
                        .font(.headline)
                    if(subtext != nil){
                        Text(subtext!)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .frame(width: 150, height: 150)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
            }
            .disabled(active)
        }
    }
}
