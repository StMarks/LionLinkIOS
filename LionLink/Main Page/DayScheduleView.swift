import SwiftUI

struct DayScheduleView: View {
    let events: [Event]
    
    var start: String? = "8:00"
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
        
                ForEach(8..<32) { hour in // Hours from 8am to 8pm.
                    HStack {
                        // Hour label on the left.
                        if(hour%2 == 0){
                            Text("\(hour):00")
                                .frame(width: 50, alignment: .trailing)
                                .padding(.trailing, 10)
                        }
                        
                        // Display the events.
                        ZStack {
                            // Display hour dividers.
                            if(hour%2 == 0){
                                Divider().background(Color.gray)
                                
                            }
                            
//                            if(hour == 9){
//                                
//                                Rectangle()
//                                    .fill(.blue)
//                                    .frame(width:200, height:60)
//                                
//                                RoundedRectangle(cornerRadius: 25)
//                                               .fill(.red)
//                                               .frame(width: 200, height: 30)
//                                Text("8 am")
//                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
//                                    .background(.blue)
//                                
////                                Rectangle
////                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
////                                    .fill(.red)
//                                
//                                               
//                                
//                            }
                            // Display the event blocks.
                            ForEach(events) { event in
                                if event.startsThisHour(hour) {
                                    TimeBlockView(event: event, startHour: hour)
                                }
                            }
                        }
                    }
                    .frame(height: 30) // Height for each hour block.
                    
                    
                    
                }
            }
        }
    }
}

