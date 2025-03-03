import SwiftUI

struct LunchMenu: Identifiable, Decodable {
    let id: Int
    let date: String 
    let mealOfDay: String
    let contents: String
}
struct DailyMenu: Identifiable, Decodable, Hashable {
    var id: Int
    var date: String
    var breakfastContents: [String]
    var lunchContents: [String]
    var dinnerContents: [String]
    
}
func groupMenusByDate(menus: [LunchMenu]) -> [DailyMenu] {
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
                id: dailyMenus.count + 1, // Assign ID based on the current count
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

//struct LunchMainView: View {
//    @ObservedObject var lunchService: LunchService
//    @State private var menus: [LunchMenu] = []
//    @State private var message: String = ""
//    @State private var menuIdToDelete: String = ""
//    @State private var newMenuId: String = ""
//    @State private var newMenuDate = Date()
//    @State private var newMenuMealOfDay: String = "Dinner"
//    @State private var newMenuContents: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    ForEach(menus) { menu in
//                        VStack(alignment: .leading) {
//                            Text("ID: \(menu.id)")
//                            Text("Date: \(menu.date)")
//                            Text("Meal: \(menu.mealOfDay)")
//                            Text("Contents: \(menu.contents)")
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                    }
//                }
//                
////                Divider()
////                
////                Group {
////                    HStack {
////                        TextField("New Menu ID", text: $newMenuId)
////                            .textFieldStyle(RoundedBorderTextFieldStyle())
////                            .keyboardType(.numberPad)
////                        DatePicker("Date", selection: $newMenuDate, displayedComponents: .date)
////                    }
//////                    TextField("Meal of Day", text: $newMenuMealOfDay)
//////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                    
////                    Picker("Meal Of Day", selection: $newMenuMealOfDay) {
////                        Text("Dinner").tag("Dinner")
////                        Text("Lunch").tag("Lunch")
////                        Text("Breakfast").tag("Breakfast")
////                    }
////                    .pickerStyle(SegmentedPickerStyle())
////                    
////                    TextField("Menu Contents", text: $newMenuContents)
////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                    Button("Create Menu") {
////                        guard let id = Int(newMenuId) else {
////                            self.message = "Please enter a valid ID"
////                            return
////                        }
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
////                        let dateString = formatter.string(from: newMenuDate)
////                        let menuData = ["id": id, "date": dateString, "mealOfDay": newMenuMealOfDay, "contents": newMenuContents] as [String : Any]
////                        lunchService.createMenu(menuData: menuData) { success, responseMessage in
////                            self.message = responseMessage
////                            if success {
////                                self.fetchMenus()
////                            }
////                        }
////                    }
////                    .buttonStyle(ActionButtonStylet(backgroundColor: .green))
////                }.padding()
//
////                Divider()
////                
////                HStack {
////                    TextField("Menu ID to delete", text: $menuIdToDelete)
////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                        .keyboardType(.numberPad)
////                    Button("Delete Menu") {
////                        guard let menuId = Int(menuIdToDelete) else {
////                            self.message = "Please enter a valid ID"
////                            return
////                        }
////                        lunchService.deleteMenu(menuId: menuId) { success, responseMessage in
////                            self.message = responseMessage
////                            if success {
////                                self.fetchMenus()
////                            }
////                        }
////                    }
////                    .buttonStyle(ActionButtonStylet(backgroundColor: .red))
////                }.padding()
////
////                if !message.isEmpty {
////                    Text(message)
////                        .foregroundColor(.primary)
////                        .padding()
////                }
//            }
//            .navigationTitle("Lunch Menu")
//            .navigationBarTitleDisplayMode(.inline)
//            .onAppear {
//                self.fetchMenus()
//            }
//        }
//    }
//    
//    private func fetchMenus() {
//        lunchService.getListOfMenus { success, menus in
//            if success {
//                self.menus = menus
//            }
//        }
//    }
//}

struct ActionButtonStylet: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

class LunchService: ObservableObject {
    
    let baseURL: URL
    let token: String
    init(token: String) {
        self.baseURL = URL(string: "\(APIConstants.baseURL)")!
        self.token = token
    }

    func getListOfMenus(completion: @escaping (Bool, [DailyMenu]) -> Void) {
        let endpoint = baseURL.appendingPathComponent("menu")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("\(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, [])
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                DispatchQueue.main.async {
                    completion(false, [])
                }
                return
            }

            do {
                let menus = try JSONDecoder().decode([LunchMenu].self, from: data)
                DispatchQueue.main.async {
                    
                    completion(true, self.groupMenusByDate(menus: menus))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, [])
                }
            }
        }.resume()
    }
    func groupMenusByDate(menus: [LunchMenu]) -> [DailyMenu] {
        var dailyMenus: [DailyMenu] = []
        for menu in menus {
            // Check if we already have an entry for this date
            if let index = dailyMenus.firstIndex(where: { $0.date == menu.date }) {
                // Update the existing DailyMenu entry for this date
//                tempDate = menu.date
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
//                    date: tempDate,
                    breakfastContents: menu.mealOfDay == "breakfast" ? [menu.contents] : [],
                    lunchContents: menu.mealOfDay == "lunch" ? [menu.contents] : [],
                    dinnerContents: menu.mealOfDay == "dinner" ? [menu.contents] : []
                )
                dailyMenus.append(newMenu)
            }
        }
        
        return dailyMenus
    }
    func createMenu(menuData: [String: Any], completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("menu")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: menuData)
        } catch {
            DispatchQueue.main.async {
                completion(false, "Error: could not encode menu data")
            }
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Create Menu Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Error: \(error.localizedDescription)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Create Menu HTTP Response: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        completion(true, "Menu created successfully")
                    }
                } else {
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("Create Menu Response Body: \(responseBody)")
                    }
                    DispatchQueue.main.async {
                        completion(false, "Failed to create menu")
                    }
                }
            }
        }.resume()
    }

    func deleteMenu(menuId: Int, completion: @escaping (Bool, String) -> Void) {
        let endpoint = baseURL.appendingPathComponent("menu/\(menuId)")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Delete Menu Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Error: \(error.localizedDescription)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Delete Menu HTTP Response: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        completion(true, "Menu deleted successfully")
                    }
                } else {
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("Delete Menu Response Body: \(responseBody)")
                    }
                    DispatchQueue.main.async {
                        completion(false, "Failed to delete menu")
                    }
                }
            }
        }.resume()
    }
    func getDateByMenuId(menuId: Int, from dailyMenus: [DailyMenu]) -> String? {
        // Search for the menu with the given ID
        if let menu = dailyMenus.first(where: { $0.id == menuId }) {
            return menu.date
        }
        // Return nil if the menu ID is not found
        return nil
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
    func formatDateFromMenuShort(from isoString: String) -> String? {
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
        outputFormatter.dateFormat = "EEEEEE" // e.g., "We"
        
        // Return the formatted date string
        return outputFormatter.string(from: date)
    }
    func formatDateFromMenuShortNum(from isoString: String) -> String? {
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
        outputFormatter.dateFormat = "dd" // e.g., "20"
        
        // Return the formatted date string
        return outputFormatter.string(from: date)
    }
    
}


