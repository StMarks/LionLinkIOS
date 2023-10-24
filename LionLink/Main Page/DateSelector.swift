import SwiftUI

// A view to display seven dates with the centered one highlighted.
struct DateSelector: View {
    @Binding var centeredDate: Date
    let dateFormatter: DateFormatter
    
    var body: some View {
        HStack(spacing: 12) { // Added a spacing for uniform spacing between the dates.
            
            // Arrow button to move the centered date backward by one day.
            Button(action: {
                centeredDate = Calendar.current.date(byAdding: .day, value: -1, to: centeredDate)!
            }) {
                Image(systemName: "arrow.left")
            }
            
            Spacer() // Separate the arrow and the date numbers.
            
            // Display three dates before the centered date, the centered date, and three dates after.
            ForEach(-3..<4) { offset in
                Text(dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: offset, to: centeredDate)!))
                    .frame(width: 30, height: 30) // Defined frame to ensure space.
                    .background(offset == 0 ? Color.blue : Color.clear)
                    .clipShape(Circle())
                    .foregroundColor(offset == 0 ? .white : .black)
                    .font(.headline) // Defined font size to ensure fitting within the circle.
            }
            
            Spacer() // Separate the arrow and the date numbers.
            
            // Arrow button to move the centered date forward by one day.
            Button(action: {
                centeredDate = Calendar.current.date(byAdding: .day, value: 1, to: centeredDate)!
            }) {
                Image(systemName: "arrow.right")
            }
        }
        .padding()
    }
}
