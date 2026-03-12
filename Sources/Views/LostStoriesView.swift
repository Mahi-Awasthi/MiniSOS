import SwiftUI

struct LostStoriesView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedScenario: Scenario? = nil
    
    struct Scenario: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        let description: String
        let fullStory: String
        let question: String
        let options: [Option]
        let color: Color
    }
    
    struct Option: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let isCorrect: Bool
        let feedback: String
    }
    
    let scenarios = [
        Scenario(
            emoji: "🏬",
            title: "At the Mall",
            description: "You are shopping with your family. You look around and cannot find them. What...",
            fullStory: "You are shopping with your family. You look around and cannot find them. What do you do?",
            question: "What would you do? Tap your answer below.",
            options: [
                Option(text: "Stay where you are and wait", isCorrect: true, feedback: "Great thinking! Staying in one place makes it much easier for your family to find you. Do not wander around."),
                Option(text: "Find a store worker or security guard", isCorrect: true, feedback: "Excellent! People with name tags or uniforms are safe helpers who can call your parents."),
                Option(text: "Walk around looking for them", isCorrect: false, feedback: "It feels natural to look, but walking around can make it harder for your family to find you. It is safer to stay in one spot.")
            ],
            color: Theme.gameYellow
        ),
        Scenario(
            emoji: "🌳",
            title: "At the Park",
            description: "You were playing at the park and now you cannot see your grown-up anywhere...",
            fullStory: "You were playing at the park and now you cannot see your grown-up anywhere. What should you do?",
            question: "Choose the best thing to do:",
            options: [
                Option(text: "Stay at the play area", isCorrect: true, feedback: "Perfect! Stay right where you are so they can find you quickly."),
                Option(text: "Look for a parent with other kids", isCorrect: true, feedback: "Smart! Other parents with children are safe people to ask for help."),
                Option(text: "Go to the parking lot", isCorrect: false, feedback: "Wait! The parking lot has moving cars and might be far from where your family is looking.")
            ],
            color: Theme.gameSky
        ),
        Scenario(
            emoji: "🏫",
            title: "After School",
            description: "School is over and no one has come to pick you up yet. You have been waiting a...",
            fullStory: "School is over and no one has come to pick you up yet. You have been waiting a long time.",
            question: "What is the safest choice?",
            options: [
                Option(text: "Go back into the school office", isCorrect: true, feedback: "Yes! The school office is the safest place to wait with teachers who care about you."),
                Option(text: "Wait outside the gate", isCorrect: false, feedback: "It's better to be inside where a teacher can see you and keep you safe."),
                Option(text: "Start walking home alone", isCorrect: false, feedback: "No, never leave school alone without your family. Always wait for them.")
            ],
            color: Theme.gameBlue
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            
            if let scenario = selectedScenario {
                ScenarioDetailView(scenario: scenario) {
                    selectedScenario = nil
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                VStack(spacing: 24) {
                    // Header
                    ZStack {
                        HStack {
                            Button(action: { 
                                SpeechManager.shared.stop()
                                dismiss() 
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Home")
                                }
                                .font(.system(.body, design: .rounded, weight: .bold))
                                .foregroundColor(Theme.gameBlue)
                            }
                            Spacer()
                        }
                        
                        Text("WHAT IF I AM LOST?")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(Theme.gameOutline)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    MascotView(expression: .happy)
                    
                    Text("Choose a situation to learn about")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(scenarios) { scenario in
                                ScenarioCard(
                                    title: scenario.title,
                                    description: scenario.description,
                                    color: scenario.color
                                ) {
                                    withAnimation(.spring()) {
                                        selectedScenario = scenario
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ScenarioDetailView: View {
    let scenario: LostStoriesView.Scenario
    let onBack: () -> Void
    @State private var selectedOption: LostStoriesView.Option? = nil
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            ZStack {
                HStack {
                    Button(action: {
                        SpeechManager.shared.stop()
                        onBack()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.gameBlue)
                    }
                    Spacer()
                }
                
                Text(scenario.title.uppercased())
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(Theme.gameOutline)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Story Card
                    Text(scenario.fullStory)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(selectedOption == nil ? Theme.gameOutline : .white)
                        .multilineTextAlignment(.leading)
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .gameCardStyle(color: scenario.color)
                    
                    // Mascot & Question
                    HStack(alignment: .top, spacing: 12) {
                        MascotView(expression: selectedOption?.isCorrect == true ? .celebrating : .thinking)
                            .frame(width: 80, height: 80)
                        
                        SpeechBubble {
                            Text(scenario.question)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Options
                    VStack(spacing: 12) {
                        ForEach(scenario.options) { option in
                            VStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring()) {
                                        selectedOption = option
                                        SpeechManager.shared.speak(option.isCorrect ? "Correct! \(option.feedback)" : "Not quite. \(option.feedback)")
                                    }
                                }) {
                                    Text(option.text)
                                        .font(.system(size: 20, weight: .black, design: .rounded))
                                        .foregroundColor(Theme.textMain)
                                        .padding(.vertical, 18)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            ZStack {
                                                Color.white
                                                if selectedOption == option {
                                                    (option.isCorrect ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                                                }
                                            }
                                        )
                                        .cornerRadius(35)
                                        .gameOutline(cornerRadius: 35)
                                        .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 3)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Feedback Box
                                if selectedOption == option {
                                    Text(option.feedback)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(Theme.textMain)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(option.isCorrect ? Theme.successGreen : Theme.errorRed)
                                        .cornerRadius(20)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
    }
}
