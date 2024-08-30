import SwiftUI

struct PlayerDetailsView: View {
    @ObservedObject var gameService: GameService
    @State private var tagPlayerIdText: String = ""
    @State private var player: Player?
    @State private var message: String = "Enter a player ID and tap 'Get Details'"

    var body: some View {
        VStack {
            TextField("Enter Player ID", text: $tagPlayerIdText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)

            Button("Get Details") {
                if let tagPlayerId = Int(tagPlayerIdText) {
                    getTagPlayerDetails(tagPlayerId: tagPlayerId)
                } else {
                    self.message = "Invalid ID. Please enter a numerical ID."
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            Text(message)
                .padding()

            if let player = self.player {
                VStack(alignment: .leading) {
                    Text("ID: \(player.id)")
                    Text("User ID: \(player.userId)")
                    Text("Playing: \(player.playing ? "Yes" : "No")")
                    Text("Current Target ID: \(player.currentTargetId ?? -1)")
                }
                .padding()
            }
        }
    }
    
    private func getTagPlayerDetails(tagPlayerId: Int) {
        gameService.getTagPlayer(tagPlayerId: tagPlayerId) { success, fetchedPlayer in
            if success, let fetchedPlayer = fetchedPlayer {
                self.player = fetchedPlayer
                self.message = "Player details fetched successfully."
            } else {
                self.message = "Could not fetch player details."
            }
        }
    }
}
