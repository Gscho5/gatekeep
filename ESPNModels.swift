//
//  ESPNModels.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import Foundation

struct ESPNScheduleResponse: Codable {
    let events: [ESPNEvent]
    
    struct ESPNEvent: Codable {
        let id: String
        let date: String
        let competitions: [ESPNCompetition]
    }
    
    struct ESPNCompetition: Codable {
        let status: ESPNStatus
        let competitors: [ESPNCompetitor]
        let conferenceCompetition: Bool?
        
        struct ESPNStatus: Codable {
            let type: StatusType
            
            struct StatusType: Codable {
                let completed: Bool
            }
        }
        
        struct ESPNCompetitor: Codable {
            let team: ESPNTeam
            let score: ESPNScore?
            let winner: Bool?
            let homeAway: String
            let statistics: [ESPNStatistic]?
            
            struct ESPNTeam: Codable {
                let id: String
                let abbreviation: String
                let displayName: String
            }
            
            struct ESPNScore: Codable {
                let displayValue: String
            }
            
            struct ESPNStatistic: Codable {
                let name: String
                let displayValue: String
            }
        }
    }
}

struct ESPNStandingsResponse: Codable {
    let children: [Conference]?
    
    struct Conference: Codable {
        let name: String
        let abbreviation: String?
        let standings: Standings?
        
        struct Standings: Codable {
            let entries: [StandingEntry]
            
            struct StandingEntry: Codable {
                let team: Team
                
                struct Team: Codable {
                    let id: String
                    let displayName: String
                    let abbreviation: String
                }
            }
        }
    }
}
