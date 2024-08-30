import SwiftUI

struct ManagementView: View {
    @State private var userId: String = ""
    @ObservedObject var gameService: GameService
    
    var body: some View {
        VStack {
            TextField("Enter User ID", text: $userId)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            HStack {
                Button("Add Player") {
                    gameService.addUserToGame(userId: userId) { success, message in
                        if success {
                            print("Player added successfully.")
                        } else {
                            print("Failed to add player: \(message)")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()

                Button("Remove Player") {
                    gameService.removeUserFromGame(userId: userId) { success, message in
                        if success {
                            print("Player removed successfully.")
                        } else {
                            print("Failed to remove player: \(message)")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
        .padding()
    }
}
