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
        ZStack{
            VStack {
                LunchDayView(lunchService: lunchService, dailyMenus:dailyMenus,todayId: todayId, todayDate:todayDate,dateSelected:todayId).ignoresSafeArea()
                
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.fetchMenus()
        }
    }
    
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

