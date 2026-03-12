import SwiftUI

struct ScenarioCard: View {
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title.uppercased())
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(Theme.gameOutline)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .gameCardStyle(color: color)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
