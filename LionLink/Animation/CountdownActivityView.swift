import SwiftUI

struct CountdownActivityView: View {
    let activity: Event

    var body: some View {
        VStack {
            Text(activity.title)
            ProgressBar(progress: computeProgress())
        }
    }

    func computeProgress() -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.date(from: activity.startTime) ?? Date()
        let endTime = formatter.date(from: activity.endTime) ?? Date()

        let totalDuration = endTime.timeIntervalSince(startTime)
        let elapsed = Date().timeIntervalSince(startTime)
        return min(max(elapsed / totalDuration, 0), 1)
    }
}

struct ProgressBar: View {
    var progress: Double

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: geometry.size.width * CGFloat(progress), height: 20)
                .foregroundColor(.blue)
                .cornerRadius(10)
        }
    }
}
