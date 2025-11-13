//
//  BriefingModels.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct BriefingCard: Identifiable, Hashable, Codable {
    let id: UUID
    let type: BriefingType
    let title: String
    let content: String
    let timestamp: String
    let isNew: Bool
    let gameId: String?
    
    init(id: UUID = UUID(), type: BriefingType, title: String, content: String, timestamp: String, isNew: Bool, gameId: String? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.isNew = isNew
        self.gameId = gameId
    }
    
    enum BriefingType: Codable {
        case gatekeep, postgame
        
        var icon: String {
            switch self {
            case .gatekeep: return "crown.fill"
            case .postgame: return "checkmark.seal.fill"
            }
        }
        
        var gradient: LinearGradient {
            switch self {
            case .gatekeep:
                return LinearGradient(
                    colors: [Color(hex: "#003262"), Color(hex: "#3B7EA1")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .postgame:
                return LinearGradient(
                    colors: [Color(hex: "#FDB515"), Color(hex: "#F2A900")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
