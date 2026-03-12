import SwiftUI

struct MascotView: View {
    let expression: Expression
    @State private var bounce = false
    
    enum Expression {
        case happy, listening, celebrating, thinking
    }
    
    var body: some View {
        ZStack {
            // Very subtle shadow instead of a glow
            Circle()
                .fill(Color.black.opacity(0.04))
                .frame(width: 120, height: 120)
                .blur(radius: 10)
                .offset(y: 5)
            
            // Mascot Image
            Image("mascot_temp")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
        }
        .scaleEffect(bounce ? 1.06 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                bounce = true
            }
        }
    }
}

struct SpeechBubble<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            content
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundColor(Theme.textMain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            // Little bubble tail
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(.white)
                .rotationEffect(.degrees(-90))
                .offset(x: -25, y: 0)
            , alignment: .leading
        )
    }
}
