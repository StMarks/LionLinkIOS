import SwiftUI

struct ExploreAllClubsView: View {
    @ObservedObject var viewModel: GroupViewModel
    @State private var searchText = ""
    @State private var selectedGroupId: Int?

    var body: some View {
        NavigationView {
            
            ScrollView {
                SearchBar(text: $searchText)
                    .padding()
                ForEach(viewModel.groups.filter {
                    searchText.isEmpty ? true : $0.name.contains(searchText)
                }) { group in
                    if group.type == "CLUB" || group.type == "ATHLETIC_TEAM"{
                        NavigationLink(destination: GeneralClubDetailView(groupId: group.id, viewModel: viewModel), tag: group.id, selection: $selectedGroupId) {
                            GroupTile(group: group, viewModel: viewModel)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                                .padding(.top, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("Explore All Clubs", displayMode: .inline)
            .onAppear {
                viewModel.fetchGroups()
            }
        }
    }
}
