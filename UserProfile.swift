//
//  UserProfile.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct UserProfile: Codable {
    let connection: FanType
    let graduationYear: String?
    let occupation: String?
    let readingTime: ReadingLength
    let priorities: [ContentPriority]
    let tonePreference: ToneStyle
    let completedOnboarding: Bool
    
    static let `default` = UserProfile(
        connection: .student,
        graduationYear: nil,
        occupation: nil,
        readingTime: .twoMinutes,
        priorities: [.gameOutcomes, .playerPerformance],
        tonePreference: .casual,
        completedOnboarding: false
    )
}

enum FanType: String, Codable, CaseIterable {
    case student = "Current Student"
    case alum = "Alumni"
    case parent = "Parent"
    case localFan = "Local Fan"
    case justLoveFootball = "Just Love Football"
    
    var icon: String {
        switch self {
        case .student: return "graduationcap.fill"
        case .alum: return "star.fill"
        case .parent: return "heart.fill"
        case .localFan: return "location.fill"
        case .justLoveFootball: return "football.fill"
        }
    }
}

enum ReadingLength: String, Codable, CaseIterable {
    case quick = "30 sec scan"
    case twoMinutes = "2 min read"
    case deepDive = "5 min deep dive"
    
    var description: String {
        switch self {
        case .quick: return "Just the highlights"
        case .twoMinutes: return "Balanced overview"
        case .deepDive: return "All the details"
        }
    }
}

enum ContentPriority: String, Codable, CaseIterable {
    case gameOutcomes = "Game Outcomes"
    case playerPerformance = "Player Stats"
    case injuries = "Injuries"
    case standings = "Standings"
    case recruiting = "Recruiting"
    case historicalContext = "History"
    
    var icon: String {
        switch self {
        case .gameOutcomes: return "trophy.fill"
        case .playerPerformance: return "person.fill"
        case .injuries: return "cross.case.fill"
        case .standings: return "chart.bar.fill"
        case .recruiting: return "star.circle.fill"
        case .historicalContext: return "book.fill"
        }
    }
}

enum ToneStyle: String, Codable, CaseIterable {
    case professional = "Professional"
    case casual = "Casual"
    case hype = "Hype"
    case facts = "Just Facts"
    
    var description: String {
        switch self {
        case .professional: return "Data-driven insights"
        case .casual: return "Like talking to a friend"
        case .hype: return "Get pumped!"
        case .facts: return "No fluff, straight info"
        }
    }
}
