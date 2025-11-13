//
//  BriefingsView.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct BriefingsView: View {
    @StateObject private var profileManager = ProfileManager.shared
    @State private var briefings: [BriefingCard] = []
    @State private var teamStats = TeamStats()
    @State private var isLoading = true
    @State private var lastUpdated: Date? = nil
    @State private var showRefreshAnimation = false
    @State private var selectedBriefing: BriefingCard? = nil
    @State private var isInitialLoad = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#0D1117").ignoresSafeArea()
                
                if isLoading && isInitialLoad {
                    PremiumLoadingView()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            headerView
                            personalizedGreeting
                            seasonOverviewSection
                            briefingList
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                    .refreshable { await checkAndRefresh(force: true) }
                }
                
                if showRefreshAnimation {
                    PremiumLoadingView()
                        .transition(.opacity)
                        .zIndex(1000)
                }
            }
            .task { await loadData() }
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedBriefing) { briefing in
                BriefingDetailView(briefing: briefing)
            }
        }
    }
    
    private var personalizedGreeting: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(getPersonalizedGreeting())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 6) {
                    Image(systemName: profileManager.profile.connection.icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#FDB515"))
                    
                    Text("\(profileManager.profile.connection.rawValue) • \(profileManager.profile.readingTime.rawValue)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#161B22"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    func getPersonalizedGreeting() -> String {
        let profile = profileManager.profile
        
        switch profile.connection {
        case .alum:
            if let year = profile.graduationYear {
                return "Welcome back, Cal '\(year)!"
            }
            return "Welcome back, Golden Bear!"
        case .student:
            return "Go Bears! Here's your update"
        case .parent:
            return "Parent's update for Cal Football"
        case .localFan:
            return "Local fan's intel drop"
        case .justLoveFootball:
            return "Football fan's briefing"
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text("gatekeep")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Circle()
                        .fill(Color(hex: "#FDB515"))
                        .frame(width: 10, height: 10)
                }
                
                Text("cal football • 2025-26")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.6))
                
                if let updated = lastUpdated {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color(hex: "#00FF87"))
                            .frame(width: 7, height: 7)
                        Text("live • updated \(updated, style: .relative) ago")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            Button(action: { hapticFeedback(.medium) }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#161B22"))
                        .overlay(
                            Circle()
                                .strokeBorder(Color(hex: "#FDB515").opacity(0.3), lineWidth: 2)
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#FDB515"))
                }
            }
        }
        .padding(.bottom, 4)
    }
    
    private var seasonOverviewSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Season Overview")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("2025 • ACC Conference")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#003262"), Color(hex: "#3B7EA1")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                    
                    HStack(alignment: .center, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overall Record")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(teamStats.record)
                                .font(.system(size: 54, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                            .frame(height: 70)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "medal.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#FDB515"))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Conference")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(teamStats.confRecord)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#FDB515"))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("ACC Rank")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(teamStats.confRank)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#FDB515"))
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Next Game")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                        Text(teamStats.nextOpponent)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(teamStats.nextGameDate)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#00FF87"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(hex: "#00FF87").opacity(0.15))
                        )
                }
                .padding(16)
                .background(Color(hex: "#161B22"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 14, x: 0, y: 5)
        }
    }
    
    private var briefingList: some View {
        VStack(spacing: 14) {
            HStack {
                Text("AI Briefings")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            LazyVStack(spacing: 14) {
                ForEach(briefings) { briefing in
                    Button(action: {
                        hapticFeedback(.medium)
                        selectedBriefing = briefing
                    }) {
                        BriefingCardView(briefing: briefing)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    func loadData() async {
        if let cache = CacheManager.shared.loadCache() {
            await MainActor.run {
                teamStats = cache.teamStats
                briefings = cache.briefings
                lastUpdated = cache.lastUpdated
                isLoading = false
                isInitialLoad = false
            }
            await checkAndRefresh(force: false)
        } else {
            await checkAndRefresh(force: true)
        }
    }
    
    func checkAndRefresh(force: Bool) async {
        if force {
            await MainActor.run {
                showRefreshAnimation = true
            }
        }
        
        do {
            let teamId = "25"
            guard let scheduleURL = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/college-football/teams/\(teamId)/schedule?season=2025") else {
                throw URLError(.badURL)
            }
            
            let (scheduleData, _) = try await URLSession.shared.data(from: scheduleURL)
            let schedule = try JSONDecoder().decode(ESPNScheduleResponse.self, from: scheduleData)
            
            let lastGame = schedule.events.last { $0.competitions.first?.status.type.completed == true }
            let nextGame = schedule.events.first { !($0.competitions.first?.status.type.completed ?? false) }
            
            let currentGameId = lastGame?.id
            let nextGameId = nextGame?.id
            
            if let cache = CacheManager.shared.loadCache(), !force {
                let shouldRefresh = CacheManager.shared.shouldRefresh(
                    cache: cache,
                    currentGameId: currentGameId,
                    nextGameId: nextGameId
                )
                
                if !shouldRefresh {
                    await MainActor.run {
                        showRefreshAnimation = false
                        isLoading = false
                        isInitialLoad = false
                    }
                    return
                }
            }
            
            await fetchFullData(schedule: schedule, lastGameId: currentGameId ?? "", nextGameId: nextGameId ?? "")
            
        } catch {
            await MainActor.run {
                showRefreshAnimation = false
                isLoading = false
                isInitialLoad = false
            }
        }
    }
    
    func fetchFullData(schedule: ESPNScheduleResponse, lastGameId: String, nextGameId: String) async {
        do {
            let teamId = "25"
            
            guard let standingsURL = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/college-football/standings?season=2025") else {
                throw URLError(.badURL)
            }
            
            let (standingsData, _) = try await URLSession.shared.data(from: standingsURL)
            let standings = try JSONDecoder().decode(ESPNStandingsResponse.self, from: standingsData)
            
            var stats = TeamStats()
            var gameDataArray: [GameData] = []
            
            let completedGames = schedule.events.filter { $0.competitions.first?.status.type.completed == true }
            
            let wins = completedGames.filter { game in
                guard let comp = game.competitions.first,
                      let cal = comp.competitors.first(where: { $0.team.abbreviation == "CAL" }) else {
                    return false
                }
                return cal.winner == true
            }.count
            
            let losses = completedGames.count - wins
            stats.record = "\(wins)-\(losses)"
            
            let confGames = completedGames.filter { $0.competitions.first?.conferenceCompetition == true }
            let confWins = confGames.filter { game in
                guard let comp = game.competitions.first,
                      let cal = comp.competitors.first(where: { $0.team.abbreviation == "CAL" }) else {
                    return false
                }
                return cal.winner == true
            }.count
            stats.confRecord = "\(confWins)-\(confGames.count - confWins) ACC"
            
            if let accConference = standings.children?.first(where: { $0.name == "Atlantic Coast Conference" || $0.abbreviation == "ACC" }),
               let accStandings = accConference.standings?.entries,
               let calEntry = accStandings.first(where: { $0.team.abbreviation == "CAL" || $0.team.displayName.contains("California") }) {
                let rank = (accStandings.firstIndex(where: { $0.team.id == calEntry.team.id }) ?? 0) + 1
                stats.confRank = "#\(rank)"
            } else {
                stats.confRank = "N/A"
            }
            
            if let nextGame = schedule.events.first(where: { !($0.competitions.first?.status.type.completed ?? false) }) {
                stats.nextGameId = nextGame.id
                
                if let opponent = nextGame.competitions.first?.competitors.first(where: { $0.team.abbreviation != "CAL" }) {
                    let homeAway = opponent.homeAway == "home" ? "@" : "vs"
                    stats.nextOpponent = "\(homeAway) \(opponent.team.displayName)"
                }
                
                let dateFormatter = ISO8601DateFormatter()
                if let date = dateFormatter.date(from: nextGame.date) {
                    let displayFormatter = DateFormatter()
                    displayFormatter.dateFormat = "MMM d"
                    stats.nextGameDate = displayFormatter.string(from: date)
                }
            }
            
            if !completedGames.isEmpty {
                var totalPoints = 0.0
                var totalAllowed = 0.0
                var totalYardsGained = 0.0
                var totalYardsAllowed = 0.0
                
                for game in completedGames {
                    if let comp = game.competitions.first,
                       let cal = comp.competitors.first(where: { $0.team.abbreviation == "CAL" }),
                       let opp = comp.competitors.first(where: { $0.team.abbreviation != "CAL" }) {
                        
                        let calScore = Double(cal.score?.displayValue ?? "0") ?? 0
                        let oppScore = Double(opp.score?.displayValue ?? "0") ?? 0
                        
                        totalPoints += calScore
                        totalAllowed += oppScore
                        
                        var calYards = 0.0
                        var oppYards = 0.0
                        
                        if let calStats = cal.statistics?.first(where: { $0.name == "totalYards" }),
                           let yards = Double(calStats.displayValue.replacingOccurrences(of: ",", with: "")) {
                            calYards = yards
                        }
                        
                        if let oppStats = opp.statistics?.first(where: { $0.name == "totalYards" }),
                           let yards = Double(oppStats.displayValue.replacingOccurrences(of: ",", with: "")) {
                            oppYards = yards
                        }
                        
                        totalYardsGained += calYards
                        totalYardsAllowed += oppYards
                        
                        gameDataArray.append(GameData(
                            gameId: game.id,
                            date: game.date,
                            opponent: opp.team.displayName,
                            pointsScored: calScore,
                            pointsAllowed: oppScore,
                            yardsGained: calYards,
                            yardsAllowed: oppYards
                        ))
                    }
                }
                
                let gamesPlayed = Double(completedGames.count)
                stats.pointsPerGame = totalPoints / gamesPlayed
                stats.pointsAllowed = totalAllowed / gamesPlayed
                stats.totalYards = totalYardsGained / gamesPlayed
                stats.yardsAllowed = totalYardsAllowed / gamesPlayed
            }
            
            stats.gameData = gameDataArray
            stats.lastGameId = lastGameId
            
            let newBriefings = generatePersonalizedBriefings(
                schedule: schedule,
                stats: stats,
                lastGameId: lastGameId,
                nextGameId: nextGameId
            )
            
            let cachedData = CachedData(
                teamStats: stats,
                briefings: newBriefings,
                lastUpdated: Date(),
                lastGameId: lastGameId,
                nextGameId: nextGameId
            )
            CacheManager.shared.saveCache(cachedData)
            
            await MainActor.run {
                teamStats = stats
                briefings = newBriefings
                lastUpdated = Date()
                isLoading = false
                isInitialLoad = false
                showRefreshAnimation = false
            }
            
        } catch {
            await MainActor.run {
                isLoading = false
                isInitialLoad = false
                showRefreshAnimation = false
            }
        }
    }
    
    func generatePersonalizedBriefings(schedule: ESPNScheduleResponse, stats: TeamStats, lastGameId: String, nextGameId: String) -> [BriefingCard] {
        var briefings: [BriefingCard] = []
        let profile = profileManager.profile
        let completedGames = schedule.events.filter { $0.competitions.first?.status.type.completed == true }
        
        let lastGame = completedGames.last
        var gatekeepContent = generateSeasonOverview(stats: stats, tone: profile.tonePreference)
        
        if let game = lastGame,
           let comp = game.competitions.first,
           let cal = comp.competitors.first(where: { $0.team.abbreviation == "CAL" }),
           let opp = comp.competitors.first(where: { $0.team.abbreviation != "CAL" }) {
            
            let calScore = cal.score?.displayValue ?? "0"
            let oppScore = opp.score?.displayValue ?? "0"
            let result = (cal.winner == true) ? "defeated" : "lost to"
            
            gatekeepContent += generateLastGameSummary(result: result, opponent: opp.team.displayName, calScore: calScore, oppScore: oppScore, tone: profile.tonePreference)
        }
        
        briefings.append(BriefingCard(
            type: .gatekeep,
            title: "Season Intelligence Report",
            content: gatekeepContent,
            timestamp: "just now",
            isNew: true,
            gameId: lastGameId
        ))
        
        if let game = lastGame,
           let comp = game.competitions.first,
           let cal = comp.competitors.first(where: { $0.team.abbreviation == "CAL" }),
           let opp = comp.competitors.first(where: { $0.team.abbreviation != "CAL" }) {
            
            let calScore = cal.score?.displayValue ?? "0"
            let oppScore = opp.score?.displayValue ?? "0"
            let result = (cal.winner == true) ? "Victory" : "Loss"
            
            let postgameContent = generatePostgameSummary(result: result, opponent: opp.team.displayName, calScore: calScore, oppScore: oppScore, tone: profile.tonePreference)
            
            briefings.append(BriefingCard(
                type: .postgame,
                title: "Last Game Analysis",
                content: postgameContent,
                timestamp: "2h ago",
                isNew: false,
                gameId: game.id
            ))
        }
        
        if profile.priorities.contains(.gameOutcomes),
           let nextGame = schedule.events.first(where: { !($0.competitions.first?.status.type.completed ?? false) }),
           let opponent = nextGame.competitions.first?.competitors.first(where: { $0.team.abbreviation != "CAL" }) {
            
            let preview = generateNextGamePreview(opponent: opponent.team.displayName, gameDate: stats.nextGameDate, tone: profile.tonePreference)
            
            briefings.append(BriefingCard(
                type: .gatekeep,
                title: "Next Game Preview",
                content: preview,
                timestamp: "5h ago",
                isNew: false,
                gameId: nextGameId
            ))
        }
        
        return briefings
    }
    
    func generateSeasonOverview(stats: TeamStats, tone: ToneStyle) -> String {
        switch tone {
        case .professional:
            return "Cal's season performance: \(stats.record) overall, \(stats.confRecord) in conference."
        case .casual:
            return "Hey! Cal's at \(stats.record) this season, \(stats.confRecord) in the ACC."
        case .hype:
            return "LET'S GO BEARS! 🐻 \(stats.record) overall and \(stats.confRecord) in conference! 💪"
        case .facts:
            return "Record: \(stats.record) | Conference: \(stats.confRecord)"
        }
    }
    
    func generateLastGameSummary(result: String, opponent: String, calScore: String, oppScore: String, tone: ToneStyle) -> String {
        switch tone {
        case .professional:
            return "\n\nMost recent: Cal \(result) \(opponent) \(calScore)-\(oppScore)."
        case .casual:
            return "\n\nLast game: We \(result) \(opponent), \(calScore)-\(oppScore)."
        case .hype:
            return result == "defeated" ? "\n\n🔥 DOMINATED \(opponent) \(calScore)-\(oppScore)!" : "\n\nLoss to \(opponent) \(calScore)-\(oppScore), we'll bounce back! 💙"
        case .facts:
            return "\n\nLast: Cal \(calScore), \(opponent) \(oppScore)"
        }
    }
    
    func generatePostgameSummary(result: String, opponent: String, calScore: String, oppScore: String, tone: ToneStyle) -> String {
        switch tone {
        case .professional:
            return "\(result) vs \(opponent): \(calScore)-\(oppScore)"
        case .casual:
            return "\(result) against \(opponent)! Final: \(calScore)-\(oppScore)"
        case .hype:
            return result == "Victory" ? "🎉 W! \(calScore)-\(oppScore) over \(opponent)!" : "Close one: \(calScore)-\(oppScore) vs \(opponent)"
        case .facts:
            return "\(result): \(calScore)-\(oppScore) vs \(opponent)"
        }
    }
    
    func generateNextGamePreview(opponent: String, gameDate: String, tone: ToneStyle) -> String {
        switch tone {
        case .professional:
            return "Upcoming: \(opponent) on \(gameDate)\n\nKey focus: Offensive consistency and defensive efficiency."
        case .casual:
            return "Next up: \(opponent) on \(gameDate)\n\nShould be a good matchup!"
        case .hype:
            return "NEXT: \(opponent) on \(gameDate) 🔥\n\nTime to DOMINATE! GO BEARS! 💙💛"
        case .facts:
            return "Next: \(opponent) • \(gameDate)"
        }
    }
}
