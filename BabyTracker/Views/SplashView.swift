import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 漸變背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.92, blue: 0.65),
                    Color(red: 0.98, green: 0.69, blue: 0.63)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Text("👶")
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                VStack(spacing: 15) {
                    // 應用標題
                    Text("寶貝成長記")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    // 副標題
                    VStack(spacing: 5) {
                        Text("基於《掌控習慣》原理")
                            .font(.body)
                        Text("記錄寶寶每一個珍貴時刻")
                            .font(.body)
                        Text("養成良好的育兒習慣")
                            .font(.body)
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                }
                
                // 載入指示器
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.top, 30)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
} 