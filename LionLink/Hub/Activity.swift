
import SwiftUI

struct Activity: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
        var iconName: String
        var destination: AnyView

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
                    }
                    .frame(width: 150, height: 150)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                }
            } else {
                NavigationLink(destination: destination) {
                    VStack {
                        Image(systemName: iconName)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text(text)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .frame(width: 150, height: 150)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
                }
            }
            
        }
}

