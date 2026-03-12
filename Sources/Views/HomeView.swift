import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Game On Banner
                ZStack {
                    ZStack {
                        Capsule()
                            .fill(Theme.gameSky)
                            .frame(width: 280, height: 70)
                        
                        Capsule()
                            .stroke(Theme.gameOutline, lineWidth: 4)
                            .frame(width: 280, height: 70)
                    }
                    
                    Text("GAME ON!")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Theme.gameOutline.opacity(0.3), radius: 0, x: 2, y: 2)
                }
                .padding(.top, 40)
                
                // Mascot Center Stage
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 180, height: 180)
                        .gameOutline(cornerRadius: 90)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    MascotView(expression: .happy)
                        .frame(height: 140)
                }
                
                Text("MiniSOS")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(Theme.gameOutline)
                
                // Adventure Buttons Grid
                VStack(spacing: 20) {
                    NavigationLink(destination: NumberPracticeView()) {
                        HStack(spacing: 15) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Theme.gameYellow)
                                    .frame(width: 50, height: 50)
                                    .gameOutline(cornerRadius: 15)
                                
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .foregroundColor(Theme.gameOutline)
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("MEMORIZE")
                                    .font(.system(size: 12, weight: .black, design: .rounded))
                                Text("NUMBER")
                                    .font(.system(size: 18, weight: .black, design: .rounded))
                            }
                            .foregroundColor(Theme.gameOutline)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(25)
                        .gameOutline(cornerRadius: 25)
                        .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: LostStoriesView()) {
                        HStack(spacing: 15) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Theme.gameBlue)
                                    .frame(width: 50, height: 50)
                                    .gameOutline(cornerRadius: 15)
                                
                                Image(systemName: "shield.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("LEARN")
                                    .font(.system(size: 12, weight: .black, design: .rounded))
                                    .foregroundColor(Theme.gameSky)
                                Text("STAY SAFE")
                                    .font(.system(size: 18, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Theme.gameBlue)
                        .cornerRadius(25)
                        .gameOutline(cornerRadius: 25)
                        .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}
