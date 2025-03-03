import SwiftUI

struct DateSelectorView: View {
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @Binding var selectedDayIndex: Int //Binding to allow ContentView to track changes
    let dates: [String]
    @Environment(\.colorScheme) var colorScheme
    
    // Compute the dates within the initializer
    init(selectedDayIndex: Binding<Int>) {
            self._selectedDayIndex = selectedDayIndex
            var calendar = Calendar.current
            calendar.firstWeekday = 2 //so it starts monday
            calendar.timeZone = TimeZone.current

            let today = Date()
            let currentWeekday = calendar.component(.weekday, from: today)
            let daysOffset = currentWeekday - calendar.firstWeekday
            let monday = calendar.date(byAdding: .day, value: -daysOffset, to: today)!

            self.dates = (0..<7).map { offset in
                let weekdayDate = calendar.date(byAdding: .day, value: offset, to: monday)!
                let formatter = DateFormatter()
                formatter.dateFormat = "dd"
                formatter.timeZone = TimeZone.current 
                return formatter.string(from: weekdayDate)
            }
        }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) { // Adjust spacing between the date boxes
                ForEach(Array(zip(weekDays.indices, weekDays)), id: \.0) { index, day in
                    Button(action: {
                        self.selectedDayIndex = index
                    }) {
                        VStack {
                            Text(day)
                                .font(.headline)
                            Text(dates[index])
                                .font(.subheadline)
                        }
                        .frame(minWidth:20,idealWidth:UIScreen.screenWidth/6,maxWidth: 200,minHeight: 30,idealHeight:50,maxHeight:60)
                        .padding(.vertical, 10)
                        .background(self.selectedDayIndex == index ? Color.blue : Color.clearNGray)
                        .foregroundColor(self.selectedDayIndex == index ? Color.black : Color.whiteNBlack)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0)
                        )
                        .scrollTransition(.interactive){content, phase in
                            content
                                .opacity(phase.isIdentity ?1:0)
                                .scaleEffect(phase.isIdentity ?1:0.7)
                            
                        }
                        
                    }
                }
            }
            .ignoresSafeArea()
            .scenePadding()
        } .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
//        if colorScheme == .dark {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) { // Adjust spacing between the date boxes
//                    ForEach(Array(zip(weekDays.indices, weekDays)), id: \.0) { index, day in
//                        Button(action: {
//                            self.selectedDayIndex = index
//                        }) {
//                            VStack {
//                                Text(day)
//                                    .font(.headline)
//                                Text(dates[index])
//                                    .font(.subheadline)
//                            }
//                            .frame(minWidth:20,idealWidth:UIScreen.screenWidth/6,maxWidth: 200,minHeight: 30,idealHeight:80,maxHeight:90)
//                            .padding(.vertical, 10)
//                            .background(self.selectedDayIndex == index ? Color.blue : Color.gray)
//                            .foregroundColor(self.selectedDayIndex == index ? Color.black : Color.white)
//                            .cornerRadius(10)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.black, lineWidth: 3)
//                            )
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//        } else {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) { // Adjust spacing between the date boxes
//                    ForEach(Array(zip(weekDays.indices, weekDays)), id: \.0) { index, day in
//                        Button(action: {
//                            self.selectedDayIndex = index
//                        }) {
//                            VStack {
//                                Text(day)
//                                    .font(.headline)
//                                Text(dates[index])
//                                    .font(.subheadline)
//                            }
//                            .frame(minWidth:20,idealWidth:UIScreen.screenWidth/6,maxWidth: 200,minHeight: 30,idealHeight:80,maxHeight:90)
//                            .padding(.vertical, 10)
//                            .background(self.selectedDayIndex == index ? Color.blue : Color.clear)
//                            .foregroundColor(self.selectedDayIndex == index ? Color.white : Color.black)
//                            .cornerRadius(10)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.black, lineWidth: 3)
//                            )
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
        
        
    }
}
