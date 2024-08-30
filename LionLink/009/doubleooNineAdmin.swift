import SwiftUI

struct doubleooNineAdmin: View {
    @AppStorage("token") var token: String?
    
    var body: some View {
        
        TabView{
            AdminActionsView(gameService: GameService(token: token!))
                .tabItem {
                    Label("Start", systemImage: "restart")
                }
//            ManagementView(gameService: GameService(token: token!))
//                .tabItem {
//                    Label("Starting Game", systemImage: "list.bullet")
//                }
//            PlayerDetailsView(gameService: GameService(token: token!))
//                .tabItem {
//                    Label("Player Details", systemImage: "list.bullet")
//                }
//            UpdateTargetView(gameService: GameService(token: token!))
//                .tabItem {
//                    Label("Update Target", systemImage: "list.bullet")
//                }
            PlayerListView(gameService: GameService(token: token!))
                .tabItem {
                    Label("All Players", systemImage: "list.bullet")
                }
            EliminateUserView(gameService: GameService(token: token!))
                .tabItem {
                    Label("ELIMINATE USER", systemImage: "list.bullet")
                }
            
//            MonitorView(gameService: GameService(token: token!))
//                .tabItem {
//                    Label("Monitor", systemImage: "magnifyingglass")
//                }
//            check(gameService: GameService(token: token!))
//                .tabItem {
//                    Label("Checking users", systemImage: "list.bullet")
//                };)
            
        }
        .navigationTitle("009 Admin ")
    }
}

struct MonitorView: View {
    @ObservedObject var gameService: GameService
    
    var body: some View {
        Text("Hello")
    }
}






