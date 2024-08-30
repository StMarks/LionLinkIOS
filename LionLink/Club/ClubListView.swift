import SwiftUI

struct ClubListView: View {
    @ObservedObject var viewModel: ClubViewModel
    @State private var searchQuery = ""
    
    var body: some View {
        VStack {
            // Search Bar
            ClubSearchBar(text: $searchQuery)
                .padding([.horizontal, .top])
            
            // Clubs List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.allGroups.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) || searchQuery.isEmpty }) { group in
                        ClubCardView(group: group,
                                      isMember: viewModel.userGroups.contains { $0.id == group.id },
                                      actionLabel: viewModel.userGroups.contains { $0.id == group.id } ? "Leave" : "Join",
                                      action: {
                                          viewModel.toggleGroupMembership(for: group)
                                      })
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

