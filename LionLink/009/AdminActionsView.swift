import SwiftUI

struct AdminActionsView: View {
    @ObservedObject var gameService: GameService
    @State private var message: String = ""
    @State private var actionInProgress: Bool = false

    var body: some View {
        
        VStack(spacing: 20) {
            Text("THESE ARE ONLY TO START THE GAME!")
                .font(.title2)
                .fontWeight(.bold)
            
            
            Button("Clear Game") {
                performAction(action: gameService.clearGame)
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .red))

            Button("Add All Users to Game") {
                performAction(action: gameService.addAllUsersToGame)
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .blue))

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.primary)
                    .padding()
                    .transition(.slide)
            }
            
            RerollTargetsView(gameService: gameService)
        }
        .disabled(actionInProgress)
        .padding()
        .navigationTitle("Starting the Game")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }

    private func performAction(action: @escaping (@escaping (Bool, String) -> Void) -> Void) {
        actionInProgress = true
        action { success, responseMessage in
            self.actionInProgress = false
            self.message = responseMessage
        }
    }
}


struct ActionButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
