import SwiftUI

struct PlayerView: View {
    @ObservedObject var gameService: GameService
    @State private var gameDetails: GameDetails?
    @State private var message: String = ""
    @State private var showingConfirmationDialog = false
    @State private var actionType: ActionType?
    @State private var targetDetails: [Int: Player] = [:]

    // Computed property to determine the background color
    var backgroundColor: Color {
        if let details = gameDetails {
            if !details.playing {
                return .red  // Not playing, show red
            } else if details.playing && ((details.target?.firstName.elementsEqual(details.user.firstName)) == true) && ((details.target?.lastName.elementsEqual(details.user.lastName)) == true) {
                return .green  // Playing and name is the same, show green
            }
        }
        return .white  // Default background color when conditions don't match
    }

    var body: some View {
        ZStack{
            backgroundColor.ignoresSafeArea()
            ScrollView {
                VStack {
                    if let details = gameDetails {
                        if details.playing && ((details.target?.firstName.elementsEqual(details.user.firstName)) == true) && ((details.target?.lastName.elementsEqual(details.user.lastName)) == true) {
                            Text("YOU WIN!")
                        } else if details.playing {
                            if let target = details.target {
                                Text("Target: \(target.firstName) (\(target.nickName)) \(target.lastName)")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    self.actionType = .tagged
                                    self.showingConfirmationDialog = true
                                }) {
                                    Text("I Tagged \(target.firstName) (\(target.nickName))! :D")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 100)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding()
                            } else {
                                Text("Target: No Target Yet")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    self.actionType = .tagged
                                    self.showingConfirmationDialog = true
                                    fetchGameDetails()
                                }) {
                                    Text("I Tagged (No Target Yet)! :D")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 100)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                            
                            Button(action: {
                                self.actionType = .taggedOut
                                self.showingConfirmationDialog = true
                                fetchGameDetails()
                            }) {
                                Text("I was Tagged! :(")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .padding()

                            
                        } else {
                            VStack {
                                Spacer()
                                Text("You've been tagged!!!!!!")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.red)
                            .edgesIgnoringSafeArea(.all)
                        }
                        Spacer()
                        Text("Eliminations: \(details.eliminations.count)")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.black)
                        Text("People Remaining: \(details.remaining)")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.black)
                    } else {
                        Text("Loading game details...")
                    }
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(Color.red)
                            .padding()
                    }
                }
            }
            .refreshable {
                fetchGameDetails()
            }
            .onAppear {
                fetchGameDetails()
            }
            .alert(isPresented: $showingConfirmationDialog) {
                Alert(
                    title: Text("Confirm Action"),
                    message: Text(actionType == .tagged ? "Are you sure you tagged your target?" : "Are you sure you were tagged?"),
                    primaryButton: .destructive(Text("Yes")) {
                        executeAction(for: actionType)
                    },
                    secondaryButton: .cancel()
                )
            }
            .padding()
        }
    }

    private func fetchGameDetails() {
        gameService.getGameDetails { success, details in
            if success, let details = details {
                self.gameDetails = details
            } else {
                self.message = "You Are Not Playing"
            }
        }
    }

    private func executeAction(for actionType: ActionType?) {
        guard let actionType = actionType else { return }
        
        switch actionType {
        case .tagged:
            gameService.eliminateTarget { success, message in
                self.message = success ? "Target successfully tagged!" : "Failed to tag the target: \(message)"
                if success {
                    fetchGameDetails()
                }
            }
        case .taggedOut:
            gameService.reportEliminatedByOther { success, message in
                self.message = success ? "Report of being tagged successful!" : "Failed to report being tagged: \(message)"
                if success {
                    fetchGameDetails()
                }
            }
        }
    }
}


enum ActionType {
    case tagged, taggedOut
}

