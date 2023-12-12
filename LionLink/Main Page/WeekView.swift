import SwiftUI

struct WeekView: View {
    @ObservedObject var viewModel: ScheduleViewModel

    var body: some View {
        TabView {
            ForEach(Array(viewModel.weeklySchedule.enumerated()), id: \.element) { index, daySchedule in
                if !daySchedule.isEmpty {
                    DayView(daySchedule: daySchedule)
                        .tabItem {
                            Label("Day \(index + 1)", systemImage: "\(index + 1).circle")
                        }
                }
            }
        }
    }
}
