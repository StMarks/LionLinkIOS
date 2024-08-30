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
                        .foregroundColor(.black)
                        
                    Text(event.abbreviatedTitle ?? "No Abbrev Title")
                        .foregroundColor(.black)
                    Text(event.location ?? "No Location")
                        .foregroundColor(.black)
                    Text(event.indvId.map { String($0) } ?? "No indvId")


                    
                    Spacer()
                        HStack(spacing: 40) {
                            if(event.indvId.map {String($0)} != nil){
                                Button("Delete", action: onDelete)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 8)
                                    .background(Color.red)
                                    .cornerRadius(5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                           
                        
                            Button("Close", action: onDismiss)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 30)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.7)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.bottom, 50) // Push up from bottom
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all) // Ensure the overlay covers the whole screen
        .onAppear {
            print("EventDetailView for \(event.title) appeared")
        }
        .onDisappear {
            print("EventDetailView for \(event.title) disappeared")
        }
    }
}
