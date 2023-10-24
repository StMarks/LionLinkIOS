import SwiftUI

struct TimeBlockView: View {
    let event: Event
    let startHour: Int
    private let hourHeight: CGFloat = 60
    
    var body: some View {
        let startY = (event.startHourFraction(from: startHour))
        let height = hourHeight * event.durationInHours()
        
        return Text(event.name)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(event.color)
            .offset(y: startY)
            .overlay(
                Text("\(event.start) - \(event.end)")
                    .foregroundColor(.white)
                    .padding(4),
                alignment: .topLeading
            )
    }
}
