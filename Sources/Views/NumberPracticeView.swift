import SwiftUI

struct NumberPracticeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var mode: ViewMode = .entry
    @State private var phoneNumber = "9877851033" // Updated to 10 digits as requested旋
    @FocusState private var isTextFieldFocused: Bool
    
    enum ViewMode {
        case entry, learning, memorize
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { 
                        if mode == .learning {
                            mode = .entry
                        } else if mode == .memorize {
                            mode = .entry
                        } else {
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(mode == .entry ? "Home" : (mode == .learning ? "Practice" : "Practice"))
                        }
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Text(mode == .learning ? "Learn the Digits" : "Say the Number")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.textMain)
                    Spacer()
                    Color.clear.frame(width: 80, height: 20)
                }
                .padding()
                
                if mode == .entry {
                    NumberEntryView(phoneNumber: $phoneNumber, onStart: {
                        withAnimation(.spring()) { mode = .memorize }
                    })
                } else if mode == .memorize {
                    NumberMemorizeView(phoneNumber: phoneNumber) {
                        mode = .entry
                    }
                } else {
                    DigitLearningView()
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct NumberEntryView: View {
    @Binding var phoneNumber: String
    let onStart: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            MascotView(expression: .happy)
                .frame(height: 120)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("For a parent or guardian")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                    Text("Enter a phone number for your child to practice. This is not saved anywhere.")
                        .font(.system(.footnote, design: .rounded))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.gameYellow.opacity(0.1))
                .gameCardStyle(color: .white)
                .foregroundColor(Theme.textMain)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone number")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.textMain)
                    
                    TextField("", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(Color.white)
                        .cornerRadius(30)
                        .gameOutline(cornerRadius: 30)
                        .focused($isFocused)
                }
                
                Button(action: onStart) {
                    Text("Start practicing")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Theme.gameBlue)
                        .cornerRadius(35)
                        .gameOutline(cornerRadius: 35)
                        .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 5)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct NumberMemorizeView: View {
    let phoneNumber: String
    let onReset: () -> Void
    
    @State private var currentStep = 0
    private var chunks: [String] {
        // Chunking strategy: 3-3-4 for 10 digits, else 3-3-3...
        var result: [String] = []
        let digits = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if digits.count == 10 {
            // 3-3-4 pattern
            let s1 = digits.index(digits.startIndex, offsetBy: 0)
            let e1 = digits.index(s1, offsetBy: 3)
            result.append(String(digits[s1..<e1]))
            
            let s2 = digits.index(digits.startIndex, offsetBy: 3)
            let e2 = digits.index(s2, offsetBy: 3)
            result.append(String(digits[s2..<e2]))
            
            let s3 = digits.index(digits.startIndex, offsetBy: 6)
            let e3 = digits.index(digits.startIndex, offsetBy: 10)
            result.append(String(digits[s3..<e3]))
        } else {
            // Fallback for other lengths (original 3-3-3...)
            var index = 0
            while index < digits.count {
                let limit = min(3, digits.count - index)
                let start = digits.index(digits.startIndex, offsetBy: index)
                let end = digits.index(start, offsetBy: limit)
                result.append(String(digits[start..<end]))
                index += limit
            }
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Progress Pills
            HStack(spacing: 8) {
                ForEach(0..<chunks.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentStep ? Theme.gameBlue : Color.gray.opacity(0.2))
                        .frame(width: index == currentStep ? 30 : 10, height: 8)
                        .gameOutline(color: Theme.gameOutline, width: 2, cornerRadius: 4)
                }
            }
            .padding(.top, 8)
            
            // Chunk Card
            VStack(spacing: 12) {
                Text("PART \(currentStep + 1) OF \(chunks.count)")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundColor(Theme.textSecondary)
                
                Text(chunks[currentStep])
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .kerning(4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .gameCardStyle(color: .white)
            .padding(.horizontal, 24)
            
            // Interaction Row
            HStack(spacing: 12) {
                MascotView(expression: .happy)
                    .frame(width: 80, height: 80)
                
                Button(action: {
                    SpeechManager.shared.speak(chunks[currentStep].map { String($0) }.joined(separator: " "))
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Theme.deepBlue)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tap to hear it!")
                                .font(.system(.body, design: .rounded, weight: .bold))
                                .foregroundColor(.black)
                            Text("Then say it out loud!")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Theme.gameOutline.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            
            // Full Number Tracker
            VStack(alignment: .leading, spacing: 12) {
                Text("FULL NUMBER")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 8) {
                    ForEach(0..<chunks.count, id: \.self) { index in
                        Text(chunks[index])
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(index == currentStep ? Theme.deepBlue : .black)
                        
                        if index < chunks.count - 1 {
                            Text("-")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            .gameCardStyle(color: .white)
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 16) {
                // Next Button
                Button(action: {
                    withAnimation {
                        if currentStep < chunks.count - 1 {
                            currentStep += 1
                        } else {
                            currentStep = 0
                        }
                    }
                }) {
                    Text("Next")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Theme.gameBlue)
                        .cornerRadius(35)
                        .gameOutline(cornerRadius: 35)
                        .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 4)
                }
                
                Button(action: onReset) {
                    Text("Change number")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.textSecondary)
                        .underline()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct DigitLearningView: View {
    @State private var currentDigit = 0
    let digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    let digitNames = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
    
    var body: some View {
        VStack(spacing: 32) {
            HStack(spacing: 8) {
                ForEach(0..<10) { index in
                    Circle()
                        .fill(index == currentDigit ? Theme.redButton : Color.gray.opacity(0.2))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 8)
            
            VStack(spacing: 12) {
                Text("\(currentDigit)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textMain)
                
                Text(digitNames[currentDigit])
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(Theme.textMain.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 60)
            .background(Theme.peach)
            .cornerRadius(35)
            .padding(.horizontal, 24)
            
            HStack(spacing: 12) {
                MascotView(expression: .happy)
                    .frame(width: 80, height: 80)
                
                Button(action: {
                    SpeechManager.shared.speak("\(currentDigit)")
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Theme.redButton)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tap to hear it")
                                .font(.system(.body, design: .rounded, weight: .bold))
                            Text("Then say it out loud!")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentDigit = (currentDigit + 1) % 10
                }
            }) {
                Text("Next")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Theme.redButton)
                    .cornerRadius(35)
                    .shadow(color: Theme.redButton.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}
