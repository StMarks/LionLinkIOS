
import SwiftUI

struct Activity: View {
    var text: String
        var iconName: String
        var destination: AnyView

        var body: some View {
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

