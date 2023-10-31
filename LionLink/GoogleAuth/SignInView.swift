import SwiftUI

struct SignInView: View {
    @State private var isNextViewActive: Bool = false

    var body: some View {
        NavigationView {
            VStack{
                Image("lion")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
                Text("Lion Link")
                    .font(Font.custom("Baskerville-Bold", size: 39))
                    .foregroundColor(.black.opacity(0.80))

                NavigationLink(
                    destination: CalendarView().navigationBarBackButtonHidden(true),
                    isActive: $isNextViewActive,
                    label: {
                        HStack {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Sign in with Google")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                    })
            }
        }
    }
}
