import SwiftUI

struct RerollTargetsView: View {
    @ObservedObject var gameService: GameService
    @State private var message: String = ""
    @State private var isRerolling: Bool = false

    var body: some View {
        VStack {
            if isRerolling {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                Button("Reroll Targets") {
                    rerollTargets()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isRerolling)
            }

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(isRerolling ? .secondary : .red)
                    .padding()
            }
        }
        .padding()
        .navigationBarTitle("Reroll Game Targets", displayMode: .inline)
    }

    private func rerollTargets() {
        isRerolling = true
        message = "Rerolling targets..."
        
        gameService.rerollTargetAssignments { success, responseMessage in
            isRerolling = false
            message = responseMessage
            if success {

            }
        }
    }
}
