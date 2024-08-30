import SwiftUI

struct LunchMenu: Identifiable, Decodable {
    let id: Int
    let date: String 
    let mealOfDay: String
    let contents: String
}

struct LunchMainView: View {
    @ObservedObject var lunchService: LunchService
    @State private var menus: [LunchMenu] = []
    @State private var message: String = ""
    @State private var menuIdToDelete: String = ""
    @State private var newMenuId: String = ""
    @State private var newMenuDate = Date()
    @State private var newMenuMealOfDay: String = "Dinner"
    @State private var newMenuContents: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(menus) { menu in
                        VStack(alignment: .leading) {
                            Text("ID: \(menu.id)")
                            Text("Date: \(menu.date)")
                            Text("Meal: \(menu.mealOfDay)")
                            Text("Contents: \(menu.contents)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
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
//                        Text("Lunch").tag("Lunch")
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
            .navigationTitle("Lunch Menu")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.fetchMenus()
            }
        }
    }
    
    private func fetchMenus() {
        lunchService.getListOfMenus { success, menus in
            if success {
                self.menus = menus
            }
        }
    }
}

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
        self.baseURL = URL(string: "https://hub-dev.stmarksschool.org/v1")!
        self.token = token
    }

    func getListOfMenus(completion: @escaping (Bool, [LunchMenu]) -> Void) {
        let endpoint = baseURL.appendingPathComponent("menu")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
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
                    completion(true, menus)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, [])
                }
            }
        }.resume()
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

}


