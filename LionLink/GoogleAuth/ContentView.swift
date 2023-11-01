import SwiftUI

struct ContentView: View {
    @AppStorage("token") var token: String?

    var body: some View {
        if let _ = token {
            CalendarView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
