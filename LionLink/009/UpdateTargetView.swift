import SwiftUI

struct UpdateTargetView: View {
    @ObservedObject var gameService: GameService
    @State private var tagPlayerIdText: String = ""
    @State private var userTargetIdText: String = ""
    @State private var message: String = ""

    var body: some View {
        VStack {
            TextField("Enter Tag Player ID", text: $tagPlayerIdText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            TextField("Enter New User Target ID", text: $userTargetIdText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button("Update Target") {
                updateTarget()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)

            if !message.isEmpty {
                Text(message)
                    .padding()
            }
        }
        .padding()
    }

    private func updateTarget() {
        guard let tagPlayerId = Int(tagPlayerIdText), let userTargetId = Int(userTargetIdText) else {
            message = "Please enter valid numeric IDs."
            return
        }

        gameService.setNewTargetForUser(tagPlayerId: tagPlayerId, userTargetId: userTargetId) { success, resultMessage in
            message = resultMessage
            if success {
                tagPlayerIdText = ""
                userTargetIdText = ""
            }
        }
    }
}


