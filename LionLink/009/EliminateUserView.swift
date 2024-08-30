import SwiftUI

struct EliminateUserView: View {
    @ObservedObject var gameService: GameService
    @State private var userIdText: String = ""
    @State private var message: String = ""
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack {
            TextField("Enter User ID", text: $userIdText)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Eliminate Player") {
                guard let userId = Int(userIdText) else {
                    message = "Invalid user ID. Please enter a numerical ID."
                    return
                }
                eliminatePlayer(userId: userId)
            }
            .disabled(isProcessing)
            .padding()
            .foregroundColor(.white)
            .background(isProcessing ? Color.gray : Color.red)
            .cornerRadius(8)

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    private func eliminatePlayer(userId: Int) {
        isProcessing = true
        gameService.eliminateUserFromGame(userId: userId) { success, responseMessage in
            isProcessing = false
            message = responseMessage
        }
    }
}
