//
//  OnboardingViews.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct OnboardingFlow: View {
    @StateObject private var profileManager = ProfileManager.shared
    @State private var currentStep = 0
    @State private var selectedConnection: FanType = .student
    @State private var graduationYear = ""
    @State private var occupation = ""
    @State private var selectedReadingTime: ReadingLength = .twoMinutes
    @State private var selectedPriorities: Set<ContentPriority> = [.gameOutcomes, .playerPerformance]
    @State private var selectedTone: ToneStyle = .casual
    
    var body: some View {
        ZStack {
            Color(hex: "#0D1117").ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index <= currentStep ? Color(hex: "#FDB515") : Color.white.opacity(0.2))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                TabView(selection: $currentStep) {
                    WelcomeView()
                        .tag(0)
                    
                    ConnectionView(selectedConnection: $selectedConnection, graduationYear: $graduationYear, occupation: $occupation)
                        .tag(1)
                    
                    ReadingTimeView(selectedReadingTime: $selectedReadingTime)
                        .tag(2)
                    
                    PrioritiesView(selectedPriorities: $selectedPriorities)
                        .tag(3)
                    
                    ToneView(selectedTone: $selectedTone)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: { withAnimation { currentStep -= 1 } }) {
                            Text("Back")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(hex: "#161B22"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    
                    Button(action: {
                        if currentStep < 4 {
                            withAnimation { currentStep += 1 }
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        Text(currentStep == 4 ? "Get Started" : "Continue")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#FDB515"), Color(hex: "#F2A900")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    func completeOnboarding() {
        let profile = UserProfile(
            connection: selectedConnection,
            graduationYear: graduationYear.isEmpty ? nil : graduationYear,
            occupation: occupation.isEmpty ? nil : occupation,
            readingTime: selectedReadingTime,
            priorities: Array(selectedPriorities),
            tonePreference: selectedTone,
            completedOnboarding: true
        )
        profileManager.saveProfile(profile)
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#003262"), Color(hex: "#3B7EA1")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "#FDB515"))
                }
                
                Text("gatekeep")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your personalized Cal Football intelligence")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "clock.fill", text: "Tailored to your schedule")
                FeatureRow(icon: "brain.head.profile", text: "AI-powered summaries")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Real-time stats & insights")
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#FDB515"))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct ConnectionView: View {
    @Binding var selectedConnection: FanType
    @Binding var graduationYear: String
    @Binding var occupation: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("What's your connection to Cal?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Help us personalize your experience")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 40)
                
                VStack(spacing: 12) {
                    ForEach(FanType.allCases, id: \.self) { type in
                        Button(action: { selectedConnection = type }) {
                            HStack(spacing: 16) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(selectedConnection == type ? Color(hex: "#FDB515") : .white.opacity(0.6))
                                    .frame(width: 30)
                                
                                Text(type.rawValue)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedConnection == type {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(hex: "#FDB515"))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "#161B22"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(
                                                selectedConnection == type ? Color(hex: "#FDB515") : Color.white.opacity(0.1),
                                                lineWidth: 2
                                            )
                                    )
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

struct ReadingTimeView: View {
    @Binding var selectedReadingTime: ReadingLength
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("How much time do you have?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We'll adjust the length of your briefings")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                ForEach(ReadingLength.allCases, id: \.self) { length in
                    Button(action: { selectedReadingTime = length }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(length.rawValue)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(length.description)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    selectedReadingTime == length ?
                                    LinearGradient(
                                        colors: [Color(hex: "#003262"), Color(hex: "#3B7EA1")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color(hex: "#161B22"), Color(hex: "#161B22")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(
                                            selectedReadingTime == length ? Color(hex: "#FDB515") : Color.white.opacity(0.1),
                                            lineWidth: 2
                                        )
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct PrioritiesView: View {
    @Binding var selectedPriorities: Set<ContentPriority>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("What matters most to you?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Select all that apply")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 40)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(ContentPriority.allCases, id: \.self) { priority in
                        Button(action: {
                            if selectedPriorities.contains(priority) {
                                selectedPriorities.remove(priority)
                            } else {
                                selectedPriorities.insert(priority)
                            }
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: priority.icon)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(
                                        selectedPriorities.contains(priority) ? Color(hex: "#FDB515") : .white.opacity(0.6)
                                    )
                                
                                Text(priority.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "#161B22"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(
                                                selectedPriorities.contains(priority) ? Color(hex: "#FDB515") : Color.white.opacity(0.1),
                                                lineWidth: 2
                                            )
                                    )
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

struct ToneView: View {
    @Binding var selectedTone: ToneStyle
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("Choose your vibe")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("How should we talk to you?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 16) {
                ForEach(ToneStyle.allCases, id: \.self) { tone in
                    Button(action: { selectedTone = tone }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tone.rawValue)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(tone.description)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#161B22"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(
                                            selectedTone == tone ? Color(hex: "#FDB515") : Color.white.opacity(0.1),
                                            lineWidth: 2
                                        )
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}
