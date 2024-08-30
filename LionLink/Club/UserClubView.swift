import SwiftUI

struct UserClubView: View {
    @ObservedObject var viewModel: ClubViewModel

    var body: some View {
        List(viewModel.userGroups, id: \.id) { group in
            NavigationLink(destination: ClubDetailView(batch: group)) {
                HStack {
                    // Image for the club - Adjust the image fetching according to your data source
                    AsyncImage(url: URL(string: group.photoUrl ?? "placeholder-image")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text(group.name)
                            .fontWeight(.bold)
                        Text(group.type)
                            .font(.subheadline)
                        Text(group.season)
                            .font(.subheadline)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("My Clubs")
    }
}
