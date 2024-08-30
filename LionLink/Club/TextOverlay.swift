import SwiftUI

struct TextOverlay: View {
    let group: Groups
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(group.name)
                    .font(.headline)
                    .padding(6)
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.black.opacity(0.7))
        }
    }
}
