import SwiftUI

struct Theme {
    // Game On! Palette
    static let gameBlue = Color(red: 0.18, green: 0.43, blue: 0.71) // #2E6EB6
    static let gameSky = Color(red: 0.47, green: 0.80, blue: 0.94)  // #79CBEF
    static let gameYellow = Color(red: 1.0, green: 0.81, blue: 0.27) // #FFCE44
    static let gameOutline = Color(red: 0.11, green: 0.23, blue: 0.37) // #1B3B5F - Bold Stroke
    
    // UI mapping
    static let terraCotta = gameYellow
    static let olive = gameBlue
    static let mustard = Color.white
    static let lavender = gameSky
    
    // Legacy mapping (pointing to new colors)
    static let peach = gameYellow
    static let mint = gameBlue
    static let redButton = gameYellow
    static let purpleButton = gameBlue
    
    // Theme compatibility aliases
    static let deepBlue = gameBlue
    static let mascotBlue = gameSky
    static let goldenOrange = gameYellow
    
    // Feedback Colors
    static let successGreen = Color(red: 0.85, green: 0.96, blue: 0.88)
    static let successGreenBorder = Color(red: 0.30, green: 0.60, blue: 0.40)
    static let errorRed = Color(red: 1.0, green: 0.90, blue: 0.90) 
    static let errorRedBorder = Color(red: 0.80, green: 0.30, blue: 0.30)
    
    static let textMain = gameOutline
    static let textSecondary = Color(red: 0.40, green: 0.50, blue: 0.60) 
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(red: 0.96, green: 0.98, blue: 1.0)]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct GameOutlineModifier: ViewModifier {
    var color: Color = Theme.gameOutline
    var width: CGFloat = 3
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: width)
            )
    }
}

extension View {
    func gameOutline(color: Color = Theme.gameOutline, width: CGFloat = 3, cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GameOutlineModifier(color: color, width: width, cornerRadius: cornerRadius))
    }
    
    func gameCardStyle(color: Color = .white) -> some View {
        self
            .padding(20)
            .background(color)
            .cornerRadius(25)
            .gameOutline(cornerRadius: 25)
            .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 4)
    }
}
