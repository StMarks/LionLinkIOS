import SwiftUI

struct CurrEvent: View {
    var eventName: String
    var backgroundColor: Color
    var startTime: String
    var endTime: String
    var events: [Event]
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(backgroundColor)
            .frame(width: 170, height: 170)
            .overlay(
                VStack(spacing: 10) {
                    
                    Text(eventName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    
                    
                }
                .padding(.all, 10)
            )
    }
}
