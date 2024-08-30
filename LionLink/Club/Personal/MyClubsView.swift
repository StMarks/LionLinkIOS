import SwiftUI

struct MyClubsView: View {
    @ObservedObject var viewModel: GroupViewModel
    @State private var searchText = ""
    @State private var selectedGroupId: Int?

    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $searchText)
                    .padding()
                ForEach(viewModel.myGroups.filter { group in
                    searchText.isEmpty || group.name.contains(searchText)
                }) { group in
                    if group.type == "CLUB" {
                        NavigationLink(destination: ClubDetailView(viewModel: viewModel, groupId: group.id)) {
                            GroupTile(group: group, viewModel: viewModel)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                                .padding(.top, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("My Clubs", displayMode: .inline)
            .onAppear {
                viewModel.fetchMyGroups()
            }
        }
    }
}
