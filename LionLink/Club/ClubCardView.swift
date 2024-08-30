import SwiftUI

struct ClubCardView: View {
    let group: Batch
    var isMember: Bool
    var actionLabel: String
    var action: () -> Void
    var body: some View {
        NavigationLink(destination: ClubDetailView(batch: group)) {
            HStack {
                //I NEED TO REMEMGBEER TO ADD A PLACEHOLDER IMAGE!!!!!
                AsyncImage(url: URL(string: group.photoUrl ?? "placeholder-image")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Action Button
                Button(action: action) {
                    Text(actionLabel)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(isMember ? Color.red : Color.blue)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        }
    }
}
