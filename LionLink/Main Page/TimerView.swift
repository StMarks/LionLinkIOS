import SwiftUI
import Combine

struct TimerView: View {
    @State private var currentTime: Date = Date()
    @State private var cancellables = Set<AnyCancellable>()

    // String representations of the start and end times
    let startTimeString: String
    let endTimeString: String
    let name: String
    let color: Color

    // Computed properties to convert string times to Date
    var startTime: Date {
        convertStringToDate(timeString: startTimeString)
    }
    var endTime: Date {
        convertStringToDate(timeString: endTimeString)
    }

    var elapsedTimeProgress: CGFloat {
        guard let elapsed = Calendar.current.dateComponents([.second], from: startTime, to: currentTime).second,
              let total = Calendar.current.dateComponents([.second], from: startTime, to: endTime).second else {
            return 0
        }
        
        return min(CGFloat(elapsed) / CGFloat(total), 1.0)
    }

    var timeDifference: String {
        if currentTime >= endTime {
            return ""
        }
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime, to: endTime)
        return String(format: "%02dh %02dm %02ds", difference.hour ?? 0, difference.minute ?? 0, difference.second ?? 0)
    }

    var gradient: AngularGradient {
        AngularGradient(gradient: Gradient(colors: [color, Color.white]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360))
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 7)
                .frame(width: 150, height: 150)

            Circle()
                .trim(from: 0, to: elapsedTimeProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 150, height: 150)

            VStack {
                Text(timeDifference)

                Text(name)
                    .font(.headline)
            }
        }
        .onAppear {
            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            
            timer
                .sink { _ in
                    self.currentTime = Date()
                }
                .store(in: &self.cancellables)
        }

        .onDisappear {
            // Stop the timer when the view disappears
        }
    }

    private func convertStringToDate(timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        let dateTimeString = todayString + " " + timeString
        return dateFormatter.date(from: dateTimeString) ?? Date()
    }
}
