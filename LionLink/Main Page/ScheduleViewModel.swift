import Foundation
import Combine
import SwiftUI


class ScheduleViewModel: ObservableObject {
    @Published var weeklySchedule: [[ScheduleItem]] = []
    @AppStorage("token") var token: String?

    func loadWeeklySchedule() {
        guard let token = token, isTodayMonday() else { return }

        NetworkManager.shared.fetchSchedule(forUserToken: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601 // Handle ISO 8601 date strings
                        let scheduleResponse = try decoder.decode(ScheduleResponse.self, from: data)
                        self?.weeklySchedule = self?.organizeScheduleByDay(scheduleItems: scheduleResponse.schedule) ?? []
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func isTodayMonday() -> Bool {
        let todayWeekday = Calendar.current.component(.weekday, from: Date())
        return todayWeekday == 2 // 2 corresponds to Monday in the Gregorian calendar
    }

    private func organizeScheduleByDay(scheduleItems: [ScheduleItem]) -> [[ScheduleItem]] {
        let groupedDictionary = Dictionary(grouping: scheduleItems) { (item: ScheduleItem) -> DateComponents in
            return Calendar.current.dateComponents([.year, .month, .day], from: item.startTime)
        }
        
        let sortedKeys = groupedDictionary.keys.sorted {
            guard let lhsDate = Calendar.current.date(from: $0), let rhsDate = Calendar.current.date(from: $1) else {
                return false
            }
            return lhsDate < rhsDate
        }
        
        return sortedKeys.compactMap { groupedDictionary[$0] }
    }
}
