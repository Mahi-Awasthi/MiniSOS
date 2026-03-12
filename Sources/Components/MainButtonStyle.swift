import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.title3, design: .rounded, weight: .bold))
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension View {
    func premiumCardStyle(color: Color) -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(color.opacity(0.15))
                    .background(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
    }
}
