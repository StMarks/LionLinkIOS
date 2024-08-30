import SwiftUI

struct GeneralClubDetailView: View {
    let groupId: Int
    @State private var group: Groups?
    @State private var isLoading = true
    @ObservedObject var viewModel: GroupViewModel
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let group = group {
                
                Text("Total Member Count: \(group.members!.count)")
                Text("Group ID: \(group.id)")
                List {
                    Section(header: Text("Events")) {
                        ForEach(group.events ?? [], id: \.id) { event in
                            Text("\(event.description)")
                            
                        }
                    }
                    Section(header: Text("Members")) {
                        ForEach(Array(group.members?.enumerated() ?? [].enumerated()), id: \.element.user.email) { index, member in
                            Text(member.user.firstName + " " + member.user.lastName)
                            Text("Grad Year: \(member.user.gradYear)")
                            Text("")
                        }
                    }

                    Section(header: Text("Announcements")) {
                        ForEach(group.announcements ?? [], id: \.id) { announcement in
                            Text(announcement.title)
                        }
                    }
                }
                .navigationTitle(group.name)
            } else {
                Text("Could not load group details.")
            }
        }
        .onAppear {
            viewModel.fetchGroupById(groupId) { fetchedGroup in
                self.group = fetchedGroup
                self.isLoading = false
            }
        }
    }
}
