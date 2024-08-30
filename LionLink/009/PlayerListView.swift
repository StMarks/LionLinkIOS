import SwiftUI

struct PlayerListView: View {
    @ObservedObject var gameService: GameService
    @State private var players: [Player] = []
    @State private var searchText: String = ""

    var filteredPlayers: [Player] {
        if searchText.isEmpty {
            return players
        } else {
            return players.filter { player in
                let playerName = "\(player.user.firstName) \(player.user.nickName) \(player.user.lastName)".lowercased()
                let targetName = "\(player.target?.firstName ?? "") \(player.target?.nickName ?? "") \(player.target?.lastName ?? "")".lowercased()
                return playerName.contains(searchText.lowercased()) || targetName.contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack {
            TextField("Search by name or target", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(filteredPlayers, id: \.id) { player in
                VStack(alignment: .leading) {
                    Text("Name: \(player.user.firstName) (\(player.user.nickName)) \(player.user.lastName) Id: \(String(player.user.id))")
                        .font(.subheadline)

                    if let target = player.target {
                        Text("Current Target: \(target.firstName) (\(target.nickName)) \(target.lastName)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("No current target")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                fetchAllPlayers()
            }
            .refreshable {
                fetchAllPlayers()
            }
        }
    }

    private func fetchAllPlayers() {
        gameService.fetchAllPlayers { success, fetchedPlayers in
            if success, let fetchedPlayers = fetchedPlayers {
                DispatchQueue.main.async {
                    self.players = fetchedPlayers
                }
            } else {
                print("Failed to fetch players.")
            }
        }
    }
}
