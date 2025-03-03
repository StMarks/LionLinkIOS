import SwiftUI

struct SignInView: View {
    @AppStorage("token") var token: String?

    var body: some View {
        CalendarView()
        
    }
}
