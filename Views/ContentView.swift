//
//  ContentView.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var profileManager = ProfileManager.shared
    
    var body: some View {
        if profileManager.hasCompletedOnboarding() {
            MainTabView()
        } else {
            OnboardingFlow()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            BriefingsView()
                .tabItem {
                    Label("Feed", systemImage: "bolt.fill")
                }
            
            BallKnowledgeView()
                .tabItem {
                    Label("Explore", systemImage: "chart.bar.fill")
                }
        }
        .tint(Color(hex: "#FDB515"))
    }
}

#Preview {
    ContentView()
}
