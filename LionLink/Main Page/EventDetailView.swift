import SwiftUI

struct EventDetailView: View {
    let event: Event
    var onDismiss: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            // Fullscreen semi-transparent background
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                .onTapGesture { onDismiss() } // Dismiss when tapped
            
            // Event detail view
            VStack {
                Spacer()
                VStack {
                    Text(event.title) // Event title
                    
                    
//                        Button("Delete", action: onDelete)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .background(Color.red)
//                                        .cornerRadius(10)
                        
                        Spacer()
                        Button("Close", action: onDismiss)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(5) // Less rounded corners
                            .frame(maxWidth: .infinity, alignment: .leading) // Align to left
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.bottom, 50) // Push up from bottom
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all) // Ensure the overlay covers the whole screen
    }
    
    
}


