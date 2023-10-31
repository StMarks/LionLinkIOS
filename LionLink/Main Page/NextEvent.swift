import SwiftUI

struct NextEvent: View {
    var eventName: String
    var backgroundColor: Color
    var startTime: String
    var endTime: String

    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(backgroundColor)
            .frame(width: 170, height: 170)
            .overlay(
                
                
                VStack(spacing: 10) {
                    Text("Next Event:")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(eventName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("(\(startTime) - \(endTime))")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    
                    
                }
                .padding(.all, 10)
            )
    }
}
