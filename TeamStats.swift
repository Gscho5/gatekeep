//
//  TeamStats.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import Foundation

struct TeamStats: Codable {
    var record: String = "0-0"
    var confRecord: String = "0-0"
    var confRank: String = "-"
    var nextOpponent: String = "TBD"
    var nextGameDate: String = "-"
    var nextGameId: String = ""
    var pointsPerGame: Double = 0.0
    var pointsAllowed: Double = 0.0
    var totalYards: Double = 0.0
    var yardsAllowed: Double = 0.0
    var gameData: [GameData] = []
    var lastGameId: String = ""
}

struct GameData: Identifiable, Codable {
    let id: UUID
    let gameId: String
    let date: String
    let opponent: String
    let pointsScored: Double
    let pointsAllowed: Double
    let yardsGained: Double
    let yardsAllowed: Double
    
    init(id: UUID = UUID(), gameId: String, date: String, opponent: String, pointsScored: Double, pointsAllowed: Double, yardsGained: Double, yardsAllowed: Double) {
        self.id = id
        self.gameId = gameId
        self.date = date
        self.opponent = opponent
        self.pointsScored = pointsScored
        self.pointsAllowed = pointsAllowed
        self.yardsGained = yardsGained
        self.yardsAllowed = yardsAllowed
    }
}

struct CachedData: Codable {
    let teamStats: TeamStats
    let briefings: [BriefingCard]
    let lastUpdated: Date
    let lastGameId: String
    let nextGameId: String
}

enum StatType {
    case pointsPerGame, pointsAllowed, totalYards, yardsAllowed
    
    var title: String {
        switch self {
        case .pointsPerGame: return "Points Per Game"
        case .pointsAllowed: return "Points Allowed"
        case .totalYards: return "Total Yards"
        case .yardsAllowed: return "Yards Allowed"
        }
    }
    
    var icon: String {
        switch self {
        case .pointsPerGame: return "flame.fill"
        case .pointsAllowed: return "shield.fill"
        case .totalYards: return "arrow.right"
        case .yardsAllowed: return "arrow.left"
        }
    }
}
