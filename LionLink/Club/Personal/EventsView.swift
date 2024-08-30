import SwiftUI

struct EventsView: View {
    let events: [ClubEvents]?
    let isUserLeader: Bool
    let onAddButtonTapped: () -> Void

    var body: some View {
        VStack {
            ForEach(events ?? [], id: \.id) { event in
                EventRow(event: event)
            }
            Spacer()
            if isUserLeader {
                Button(action: onAddButtonTapped) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(16)
                }
            }
        }
    }
}
