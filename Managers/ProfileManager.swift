//
//  ProfileManager.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI
import Combine

class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    private let profileKey = "gatekeep_user_profile"
    
    @Published var profile: UserProfile
    
    init() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = decoded
        } else {
            self.profile = .default
        }
    }
    
    func saveProfile(_ profile: UserProfile) {
        self.profile = profile
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    func hasCompletedOnboarding() -> Bool {
        return profile.completedOnboarding
    }
}
