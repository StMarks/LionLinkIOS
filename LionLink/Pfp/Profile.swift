import SwiftUI
import PhotosUI

struct Profile: View {
    @AppStorage("isDarkMode") public var isDarkMode: Bool = false
    @AppStorage("tokenClear") public var tokenClear: Bool = false
    @AppStorage("token") var token: String?
    @State private var centeredDate = Date()

    private var monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df
    }()

    @State var shouldShowImagePicker = false
    @State var image: UIImage?
         
        var body: some View {
            CalendarNavBar(month: monthFormatter.string(from: centeredDate))

            NavigationView {
                VStack {
                    VStack {
                        ZStack(alignment: .top) {
                            Rectangle()
                                .foregroundColor(Color.blue)
                                .edgesIgnoringSafeArea(.top)
                                .frame(height: 100)
                             
                            Button {
                                shouldShowImagePicker.toggle()
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 143, height: 143)
                                            .cornerRadius(80)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 80))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 80)
                                            .stroke(Color.black, lineWidth: 3)
                                )
                            }
                        }//end Zstack
                    }
                     
                    VStack(spacing: 15) {
                        VStack(spacing: 5) {
                            Text(token ?? "fail")
                                .bold()
                                .font(.title)

                        }.padding()
                        
                    }
                    Spacer()
                    
                    
                    Button("Clear Token") {
                        token = nil
                    }
                    .padding(.horizontal)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
}


struct CustomColorSchemeKey: EnvironmentKey {
    static let defaultValue: ColorScheme? = nil
}

extension EnvironmentValues {
    var customColorScheme: ColorScheme? {
        get { self[CustomColorSchemeKey.self] }
        set { self[CustomColorSchemeKey.self] = newValue }
    }
}

