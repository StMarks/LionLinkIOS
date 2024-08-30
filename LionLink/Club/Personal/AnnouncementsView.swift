import SwiftUI

struct AnnouncementsView: View {
    let announcements: [Announcement]?
    let isUserLeader: Bool
    let onAddButtonTapped: () -> Void

    var body: some View {
        VStack {
            ForEach(announcements ?? [], id: \.id) { announcement in
                VStack(alignment: .leading) {
                    Text(announcement.title).font(.headline).padding(.top)
                    Text(announcement.content).font(.subheadline)
                    Divider()
                }.padding(.horizontal)
            }
            Spacer()
            if isUserLeader {
                Button(action: onAddButtonTapped) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(16)
                }
            }
        }
    }
}
