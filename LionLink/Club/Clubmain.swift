import SwiftUI
import Combine

struct Clubmain: View {
    @ObservedObject var viewModel = GroupViewModel()

    var body: some View {
        ClubNavBar()
        TabView {
            ExploreAllClubsView(viewModel: viewModel)
                .tabItem {
                    Label("Explore All Clubs", systemImage: "magnifyingglass")
                }

            MyClubsView(viewModel: viewModel)
                .tabItem {
                    Label("My Clubs", systemImage: "person.3.fill")
                }
        }
    }
}











class GroupViewModel: ObservableObject {
    @Published var groups: [Groups] = []
        @Published var myGroups: [Groups] = []
        @Published var currentUser: Users?
        var selectedGroupId: Int?
        @AppStorage("token") var token: String?

    private var groupService: GroupService? {
        if let token = token {
            return GroupService(token: token)
        }
        return nil
    }

    
    var cancellables = Set<AnyCancellable>()

    func fetchCurrentUser() {
        guard let token = token,
              let userProfileURL = URL(string: "https://hub-dev.stmarksschool.org/v1/auth/user") else {
            print("No token available or invalid URL.")
            return
        }
        
        var request = URLRequest(url: userProfileURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .decode(type: Users.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
            }, receiveValue: { [weak self] user in
                self?.currentUser = user
                print("Current user fetched: \(user)")
            })
            .store(in: &cancellables)
    }

    
    func fetchGroups() {
        guard let service = groupService else {
            print("No token available.")
            return
        }

        service.fetchBatch { [weak self] fetchedGroups in
            if let fetchedGroups = fetchedGroups {
                self?.groups = fetchedGroups
            } else {
                print("Error fetching groups or no groups available.")
            }
        }
    }

    func fetchMyGroups() {
        guard let service = groupService else {
            print("No token available.")
            return
        }

        service.fetchIndvBatch { [weak self] fetchedGroups in
            DispatchQueue.main.async {
                if let fetchedGroups = fetchedGroups {
                    self?.myGroups = fetchedGroups
                } else {
                    print("Error fetching my groups or no groups available.")
                }
            }
        }
    }


    func isUserAMember(of groupId: Int) -> Bool {
        return myGroups.contains { $0.id == groupId }
    }

    func joinGroup(withId id: Int) {
        guard let service = groupService else {
            print("No token available.")
            return
        }

        service.joinClub(with: id) { [weak self] success, message in
            if success {
                print("Successfully joined the group.")

                self?.fetchMyGroups()
            } else {
                print("Failed to join the group: \(message)")
            }
        }
    }

    func leaveGroup(withId id: Int) {
        guard let service = groupService else {
            print("No token available.")
            return
        }

        service.leaveClub(with: id) { [weak self] success, message in
            if success {
                print("Successfully left the group.")
                // Fetch groups again to update the UI
                self?.fetchMyGroups()
            } else {
                print("Failed to leave the group: \(message)")
            }
        }
    }


    func fetchGroupById(_ id: Int, completion: @escaping (Groups?) -> Void) {
        groupService?.fetchGroupsById(id, completion: completion)
    }
    
    func isUserLeader(group: Groups?) -> Bool {
        guard let group = group,
              let currentUserId = self.currentUser?.id else { return false }
        return group.members?.contains(where: {
            $0.groupRole == "LEADER" && $0.userId == currentUserId
        }) ?? false
    }

}














