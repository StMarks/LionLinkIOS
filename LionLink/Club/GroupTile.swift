import SwiftUI

struct GroupTile: View {
    let group: Groups
    @ObservedObject var viewModel: GroupViewModel
    @State private var showingLeaveAlert = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                if let photo = group.photo, let url = URL(string: photo) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                }

                TextOverlay(group: group)

                Button(action: {
                    if viewModel.isUserAMember(of: group.id) {
                        // Trigger the alert
                        showingLeaveAlert = true
                    } else {
                        viewModel.joinGroup(withId: group.id)
                    }
                }) {
                    Image(systemName: viewModel.isUserAMember(of: group.id) ? "checkmark" : "plus")
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModel.isUserAMember(of: group.id) ? Color.green : Color.blue)
                        .clipShape(Circle())
                        .padding(10)
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
        .alert(isPresented: $showingLeaveAlert) {
            Alert(
                title: Text("Confirm Leave"),
                message: Text("Are you sure you want to leave this group?"),
                primaryButton: .destructive(Text("Leave")) {
                    viewModel.leaveGroup(withId: group.id)
                },
                secondaryButton: .cancel()
            )
        }
    }
}
