import SwiftUI

struct ClubDetailView: View {
    @ObservedObject var viewModel: GroupViewModel
    let groupId: Int
    
    @State private var detailedGroup: Groups?
        @State private var isLoading = true
        @State private var showingAddAnnouncement = false
        @State private var showingAddEvent = false
        @State private var isUserLeader = false
        @State private var selectedTab: Int = 0
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let detailedGroup = detailedGroup {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(detailedGroup.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        HStack {
                            ForEach(detailedGroup.members?.filter { $0.groupRole == "LEADER" } ?? [], id: \.id) { leader in
                                Text(leader.user.preferredName ?? "\(leader.user.firstName) \(leader.user.lastName)")
                                    .font(.headline)
                                    .padding(.horizontal, 4)
                            }
                        }
                        
                        Picker("Options", selection: $selectedTab) {
                            Text("Announcements").tag(0)
                            Text("Events").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        if selectedTab == 0 {
                                                    AnnouncementsView(announcements: detailedGroup.announcements, isUserLeader: isUserLeader) {
                                                        showingAddAnnouncement = true
                                                    }
                                                    .sheet(isPresented: $showingAddAnnouncement) {
                                                        // Replace with your actual AddAnnouncementView
                                                        Text("Add Announcement View goes here")
                                                    }
                                                } else {
                                                    EventsView(events: detailedGroup.events, isUserLeader: isUserLeader) {
                                                        showingAddEvent = true
                                                    }
                                                    .sheet(isPresented: $showingAddEvent) {
                                                        // Replace with your actual AddEventView
                                                        Text("Add Event View goes here")
                                                    }
                                                }
                    }
                }
            } else {
                Text("Could not load club details.")
            }
        }
        .onAppear {
                    viewModel.fetchCurrentUser()
                    viewModel.fetchGroupById(groupId) { fetchedGroup in
                        self.detailedGroup = fetchedGroup
                        self.isLoading = false
                    }
                }
        .onChange(of: viewModel.unwrappedCurrentUser) { _ in
            // This will trigger when currentUser is updated and is non-nil
            if let group = detailedGroup {
                self.isUserLeader = viewModel.isUserLeader(group: group)
            }
        }

    }
}

extension GroupViewModel {
    var unwrappedCurrentUser: Users? {
        return currentUser
    }
}
