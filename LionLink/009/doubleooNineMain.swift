import SwiftUI

struct doubleooNineMain: View {
    @AppStorage("token") var token: String?

    var body: some View {
        NavigationView {
            if let token = token {
                VStack {
                    NavigationLink("Add/Remove Players", destination: ManagementView(gameService: GameService(token: token)))
                    NavigationLink("Get Player From ID", destination: PlayerDetailsView(gameService: GameService(token: token)))
                    NavigationLink("Update Target View", destination: UpdateTargetView(gameService: GameService(token: token)))
                    NavigationLink("View All Players", destination: PlayerListView(gameService: GameService(token: token)))
                    NavigationLink("Player View", destination: PlayerView(gameService: GameService(token: token)))
                    NavigationLink("REROLLLLL", destination: RerollTargetsView(gameService: GameService(token: token)))
                }
            } else {
                Text("No token available - Please log in")
            }
        }
        .navigationTitle("009 Main Dashboard")
    }
}


