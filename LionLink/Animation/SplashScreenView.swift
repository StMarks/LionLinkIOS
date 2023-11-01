import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.3
    @State private var opacity = 0.5
    
    
    
    var body: some View {
        if isActive{
            ContentView()
        }else{
            VStack{
                VStack{
                    Image("lion")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    Text("Lion Link")
                        .font(Font.custom("Baskerville-Bold", size: 26))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 2.2)){
                        self.size = 1.5
                        self.opacity = 1.0
                        
                    }
                    
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6){
                    self.isActive = true
                }
            }
        }
        
    }
}
