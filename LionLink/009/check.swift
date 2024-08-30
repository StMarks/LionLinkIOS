import SwiftUI

struct check: View {
    
    @ObservedObject var gameService: GameService
    @State private var start: Date
    @State private var end: Date
    @State private var minimum: String

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Minimum Eliminations", text: $minimum)
                    DatePicker("Start Time", selection: $start, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Time", selection: $end, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationBarTitle("Create Event", displayMode: .inline)

            Button("Generate List") {
                getPlayersCheck()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)

        }
        .padding()
    }

    private func getPlayersCheck() {
//        guard let tagPlayerId = Int(tagPlayerIdText), let userTargetId = Int(userTargetIdText) else {
//            message = "Please enter valid numeric IDs."
//            return
//        }

        gameService.roundMinCheck(startDate: 1, endDate: 1, minimum: 1) { success, resultMessage in
            
        }
    }
}
