//
//  LunchMainView.swift
//  LionLink
//
//  Created by Liam Bean on 10/28/24.
//

import SwiftUI

struct LunchMainView: View {
    @ObservedObject var lunchService: LunchService
    @State private var menus: [LunchMenu] = []
    @State var dailyMenus: [DailyMenu] = []
    @State private var message: String = ""
    @State private var menuIdToDelete: String = ""
    @State private var newMenuId: String = ""
    @State private var todayId: Int = 0
    @State private var todayDate: String = ""
    @State private var newMenuDate = Date()
    @State private var newMenuMealOfDay: String = "Dinner"
    @State private var newMenuContents: String = ""
    @State private var selectedIndex: Int = 0
    func setSelectedIndexBasedOnDay() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        selectedIndex = (weekday + 5) % 7
    }
    func groupMenusByDate() -> [DailyMenu] {
        var dailyMenus: [DailyMenu] = []

        for menu in menus {
            // Check if we already have an entry for this date
            if let index = dailyMenus.firstIndex(where: { $0.date == menu.date }) {
                // Update the existing DailyMenu entry for this date
                switch menu.mealOfDay {
                case "breakfast":
                    dailyMenus[index].breakfastContents.append(menu.contents)
                case "lunch":
                    dailyMenus[index].lunchContents.append(menu.contents)
                case "dinner":
                    dailyMenus[index].dinnerContents.append(menu.contents)
                default:
                    break
                }
            } else {
                // Create a new DailyMenu entry for this date
                let newMenu = DailyMenu(
                    id: dailyMenus.count + 1,
                    date: menu.date,
                    breakfastContents: menu.mealOfDay == "breakfast" ? [menu.contents] : [],
                    lunchContents: menu.mealOfDay == "lunch" ? [menu.contents] : [],
                    dinnerContents: menu.mealOfDay == "dinner" ? [menu.contents] : []
                )
                dailyMenus.append(newMenu)
            }
        }
        
        return dailyMenus
    }
    var body: some View {
            GeneralNavBar(title:"Dining")
        
//        NavigationView {
            ZStack{
                VStack {
                    //                    Button(){
                    ////                        print(Date())
                    ////                          print(menus)
                    ////                        print(menus.randomElement()!)
                    ////                        print(menus.randomElement()!.mealOfDay)
                    ////                        print(menus.randomElement()!.contents)
                    ////                        print(menus.randomElement()!.date)
                    ////                        print(formattedDate(Date()))
                    ////                        print(formatDateFromMenu(from: findTodaysMenu().randomElement()!.date)!)
                    ////                        print(findTodaysMenu())
                    //                          print(dailyMenus)
                    //
                    //                    }label:{
                    //                        Text("Hi")
                    //                    }
                    //                    DateSelectorView(selectedDayIndex: $selectedIndex)
                    
                    LunchDayView(lunchService: lunchService, dailyMenus:dailyMenus,todayId: todayId, todayDate:todayDate,dateSelected:todayId).ignoresSafeArea()
                    
                    
                }
                //                Divider()
                //
                //                Group {
                //                    HStack {
                //                        TextField("New Menu ID", text: $newMenuId)
                //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                //                            .keyboardType(.numberPad)
                //                        DatePicker("Date", selection: $newMenuDate, displayedComponents: .date)
                //                    }
                ////                    TextField("Meal of Day", text: $newMenuMealOfDay)
                ////                        .textFieldStyle(RoundedBorderTextFieldStyle())
                //
                //                    Picker("Meal Of Day", selection: $newMenuMealOfDay) {
                //                        Text("Dinner").tag("Dinner")
                //                          Text("Lunch").tag("Lunch")
                //                        Text("Breakfast").tag("Breakfast")
                //                    }
                //                    .pickerStyle(SegmentedPickerStyle())
                //
                //                    TextField("Menu Contents", text: $newMenuContents)
                //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                //                    Button("Create Menu") {
                //                        guard let id = Int(newMenuId) else {
                //                            self.message = "Please enter a valid ID"
                //                            return
                //                        }
                //                        let formatter = DateFormatter()
                //                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //                        let dateString = formatter.string(from: newMenuDate)
                //                        let menuData = ["id": id, "date": dateString, "mealOfDay": newMenuMealOfDay, "contents": newMenuContents] as [String : Any]
                //                        lunchService.createMenu(menuData: menuData) { success, responseMessage in
                //                            self.message = responseMessage
                //                            if success {
                //                                self.fetchMenus()
                //                            }
                //                        }
                //                    }
                //                    .buttonStyle(ActionButtonStylet(backgroundColor: .green))
                //                }.padding()
                
                //                Divider()
                //
                //                HStack {
                //                    TextField("Menu ID to delete", text: $menuIdToDelete)
                //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                //                        .keyboardType(.numberPad)
                //                    Button("Delete Menu") {
                //                        guard let menuId = Int(menuIdToDelete) else {
                //                            self.message = "Please enter a valid ID"
                //                            return
                //                        }
                //                        lunchService.deleteMenu(menuId: menuId) { success, responseMessage in
                //                            self.message = responseMessage
                //                            if success {
                //                                self.fetchMenus()
                //                            }
                //                        }
                //                    }
                //                    .buttonStyle(ActionButtonStylet(backgroundColor: .red))
                //                }.padding()
                //
                //                if !message.isEmpty {
                //                    Text(message)
                //                        .foregroundColor(.primary)
                //                        .padding()
                //                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.fetchMenus()
//                self.findTodaysMenu()
            }
        }
//    }
    
    private func fetchMenus() {
        lunchService.getListOfMenus { success, menus in
            if success {
                self.dailyMenus = menus
            }
            for menu in menus{
                if formattedDate(Date()) == formatDateFromMenu(from: menu.date) {
                    self.todayId = menu.id
                    self.todayDate = menu.date
                }
            }
        }
    }
    private func fixMenu(){
        self.dailyMenus = groupMenusByDate()
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: date)
    }
    func formatDateFromMenu(from isoString: String) -> String? {
        // Create a DateFormatter for the ISO string
        let isoFormatter = DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: +14400)
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        
        // Convert the string to a Date
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        // Create another DateFormatter for the output format
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone(secondsFromGMT: +14400)
        outputFormatter.dateFormat = "E, MMM d" // e.g., "Wed, Nov 20"
        
        // Return the formatted date string
        return outputFormatter.string(from: date)
    }
    
}

