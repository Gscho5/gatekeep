//
//  BallKnowledgeView.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI
import Combine

// MARK: - Trivia Models

struct TriviaQuestion: Identifiable {
    let id = UUID()
    let question: String
    let answers: [String]
    let correctAnswer: Int
    let difficulty: Difficulty
    let category: Category
    
    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Category: String {
        case history = "History"
        case players = "Players"
        case records = "Records"
        case rivals = "Rivals"
    }
}

struct TriviaScore: Codable {
    var totalCorrect: Int = 0
    var totalAttempted: Int = 0
    var streak: Int = 0
    var bestStreak: Int = 0
}

class TriviaManager: ObservableObject {
    @Published var score = TriviaScore()
    private let scoreKey = "gatekeep_trivia_score"
    
    init() {
        loadScore()
    }
    
    func loadScore() {
        if let data = UserDefaults.standard.data(forKey: scoreKey),
           let decoded = try? JSONDecoder().decode(TriviaScore.self, from: data) {
            score = decoded
        }
    }
    
    func saveScore() {
        if let encoded = try? JSONEncoder().encode(score) {
            UserDefaults.standard.set(encoded, forKey: scoreKey)
        }
    }
    
    func answerQuestion(correct: Bool) {
        score.totalAttempted += 1
        if correct {
            score.totalCorrect += 1
            score.streak += 1
            if score.streak > score.bestStreak {
                score.bestStreak = score.streak
            }
        } else {
            score.streak = 0
        }
        saveScore()
    }
    
    var accuracy: Double {
        guard score.totalAttempted > 0 else { return 0 }
        return Double(score.totalCorrect) / Double(score.totalAttempted) * 100
    }
}

// MARK: - Trivia Questions Database

class TriviaDatabase {
    static let questions: [TriviaQuestion] = [
        // History Questions
        TriviaQuestion(
            question: "In what year did Cal win its first Rose Bowl?",
            answers: ["1920", "1921", "1922", "1923"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .history
        ),
        TriviaQuestion(
            question: "What is Cal's official football stadium called?",
            answers: ["Memorial Stadium", "California Stadium", "Golden Bear Arena", "Berkeley Bowl"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .history
        ),
        TriviaQuestion(
            question: "What year did Cal join the ACC conference?",
            answers: ["2022", "2023", "2024", "2025"],
            correctAnswer: 2,
            difficulty: .medium,
            category: .history
        ),
        
        // Players Questions
        TriviaQuestion(
            question: "Which Cal quarterback won the Heisman Trophy?",
            answers: ["Aaron Rodgers", "Jared Goff", "Joe Kapp", "None - Cal has never had a Heisman winner"],
            correctAnswer: 3,
            difficulty: .medium,
            category: .players
        ),
        TriviaQuestion(
            question: "Which Cal player went #1 overall in the 2016 NFL Draft?",
            answers: ["Marshawn Lynch", "Jared Goff", "Aaron Rodgers", "DeSean Jackson"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .players
        ),
        TriviaQuestion(
            question: "What jersey number did Marshawn Lynch wear at Cal?",
            answers: ["22", "23", "24", "10"],
            correctAnswer: 2,
            difficulty: .hard,
            category: .players
        ),
        
        // Records Questions
        TriviaQuestion(
            question: "What is Cal's most wins in a single season in the modern era?",
            answers: ["10", "11", "12", "13"],
            correctAnswer: 3,
            difficulty: .hard,
            category: .records
        ),
        TriviaQuestion(
            question: "How many Rose Bowl appearances has Cal made?",
            answers: ["2", "3", "4", "5"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .records
        ),
        
        // Rivals Questions
        TriviaQuestion(
            question: "What is the name of the trophy awarded in the Cal-Stanford game?",
            answers: ["The Axe", "The Golden Bear", "The Tree", "The Victory Bell"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .rivals
        ),
        TriviaQuestion(
            question: "The Big Game refers to Cal's rivalry with which school?",
            answers: ["UCLA", "USC", "Stanford", "Oregon"],
            correctAnswer: 2,
            difficulty: .easy,
            category: .rivals
        ),
        TriviaQuestion(
            question: "What famous play occurred in the 1982 Big Game?",
            answers: ["The Catch", "The Play", "The Drive", "The Fumble"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .rivals
        ),
        TriviaQuestion(
            question: "In what year was the University of California, Berkeley’s football program founded?",
            answers: ["1886", "1890", "1896", "1901"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .history
        ),

        TriviaQuestion(
            question: "What is the official name of Cal’s football stadium?",
            answers: ["California Memorial Stadium", "Berkeley Bowl", "Haas Stadium", "Golden Bear Field"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .history
        ),

        TriviaQuestion(
            question: "The 1920s Cal football dynasty under head coach Andy Smith was nicknamed what?",
            answers: ["The Wonder Teams", "The Bear Era", "The Blue Wave", "The Smith Machine"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .history
        ),

        TriviaQuestion(
            question: "Which Cal coach led the team to a Rose Bowl victory in 1938?",
            answers: ["Lynn 'Pappy' Waldorf", "Jeff Tedford", "Stub Allison", "Andy Smith"],
            correctAnswer: 2,
            difficulty: .hard,
            category: .history
        ),

        TriviaQuestion(
            question: "Cal Football’s colors, blue and gold, were chosen to represent what?",
            answers: ["California’s sky and fields", "The school seal", "Berkeley’s hills and sunsets", "State pride and loyalty"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .history
        ),

        TriviaQuestion(
            question: "What was Cal’s first-ever bowl game appearance?",
            answers: ["1921 Rose Bowl", "1938 Rose Bowl", "1949 Pineapple Bowl", "1950 Rose Bowl"],
            correctAnswer: 0,
            difficulty: .hard,
            category: .history
        ),

        TriviaQuestion(
            question: "The ‘Big C’ on the Berkeley hills was first constructed in what year?",
            answers: ["1900", "1905", "1910", "1915"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .history
        ),

        TriviaQuestion(
            question: "Which war is California Memorial Stadium dedicated to those who served in?",
            answers: ["World War I", "World War II", "Korean War", "Vietnam War"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .history
        ),

        TriviaQuestion(
            question: "Which Cal head coach was responsible for the team’s modern offensive resurgence in the 2000s?",
            answers: ["Mike White", "Keith Gilbertson", "Jeff Tedford", "Sonny Dykes"],
            correctAnswer: 2,
            difficulty: .easy,
            category: .history
        ),

        TriviaQuestion(
            question: "In what year did Cal officially join the Pac-10 Conference (now Pac-12)?",
            answers: ["1915", "1959", "1968", "1978"],
            correctAnswer: 3,
            difficulty: .medium,
            category: .history
        ),

        TriviaQuestion(
            question: "Cal’s football program was temporarily dropped in 1906 for what reason?",
            answers: ["Safety concerns", "Lack of funding", "World War I", "Poor attendance"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .history
        ),

        TriviaQuestion(
            question: "Which team did Cal face in their first-ever football game?",
            answers: ["Stanford", "San Jose State", "Nevada", "Santa Clara"],
            correctAnswer: 0,
            difficulty: .hard,
            category: .history
        ),
        TriviaQuestion(
            question: "Which Cal quarterback was the #1 overall pick in the 2016 NFL Draft?",
            answers: ["Aaron Rodgers", "Jared Goff", "Davis Webb", "Nate Longshore"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "Aaron Rodgers transferred to Cal from which community college?",
            answers: ["Laney College", "Butte College", "Diablo Valley College", "City College of San Francisco"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal running back won the 1959 Heisman Trophy?",
            answers: ["Chuck Muncie", "Craig Morton", "Joe Kapp", "Pete Elliott"],
            correctAnswer: 0,
            difficulty: .hard,
            category: .players
        ),

        TriviaQuestion(
            question: "Marshawn Lynch famously rode what vehicle on the field after a 2006 win?",
            answers: ["Golf cart", "Motorcycle", "Scooter", "ATV"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "DeSean Jackson played what primary position at Cal?",
            answers: ["Quarterback", "Running back", "Wide receiver", "Cornerback"],
            correctAnswer: 2,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal player later became a Super Bowl MVP with the Green Bay Packers?",
            answers: ["Aaron Rodgers", "Desmond Bishop", "Keenan Allen", "Cam Jordan"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "Joe Kapp, Cal’s 1958 quarterback, also played professionally in which league?",
            answers: ["NFL", "AFL", "CFL", "USFL"],
            correctAnswer: 2,
            difficulty: .medium,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal alumnus became head coach of the Washington Commanders in 2024?",
            answers: ["Marshawn Lynch", "Ron Rivera", "Troy Taylor", "Mike Silvera"],
            correctAnswer: 1,
            difficulty: .hard,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal player was known for the nickname 'Beast Mode'?",
            answers: ["Aaron Rodgers", "Marshawn Lynch", "DeSean Jackson", "Shane Vereen"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal linebacker won the 2006 Pac-10 Defensive Player of the Year?",
            answers: ["Desmond Bishop", "Zack Follett", "Mychal Kendricks", "Hardy Nickerson"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .players
        ),

        TriviaQuestion(
            question: "Who holds Cal’s record for most career receiving touchdowns?",
            answers: ["DeSean Jackson", "Keenan Allen", "Geoff McArthur", "Marvin Jones"],
            correctAnswer: 0,
            difficulty: .hard,
            category: .players
        ),

        TriviaQuestion(
            question: "Which former Cal running back was drafted by the New England Patriots in 2011?",
            answers: ["Marshawn Lynch", "Shane Vereen", "C.J. Anderson", "Justin Forsett"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .players
        ),

        TriviaQuestion(
            question: "Which Cal player was the first pick of the 1959 NFL Draft?",
            answers: ["Craig Morton", "Chuck Muncie", "Randy Duncan", "Joe Kapp"],
            correctAnswer: 2,
            difficulty: .hard,
            category: .players
        ),
        TriviaQuestion(
            question: "Who holds Cal’s record for most passing yards in a single season?",
            answers: ["Jared Goff", "Aaron Rodgers", "Kyle Boller", "Pat Barnes"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .records
        ),

        TriviaQuestion(
            question: "What is Cal’s largest margin of victory ever recorded?",
            answers: ["66 points", "72 points", "82 points", "86 points"],
            correctAnswer: 2,
            difficulty: .hard,
            category: .records
        ),

        TriviaQuestion(
            question: "How many times has Cal appeared in the Rose Bowl?",
            answers: ["5", "7", "8", "9"],
            correctAnswer: 3,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "What is Cal’s all-time record against Stanford (as of 2024)?",
            answers: ["Leads series", "Trails series", "Tied", "Stanford leads by 1"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "Which Cal quarterback holds the record for most touchdown passes in a game?",
            answers: ["Jared Goff", "Aaron Rodgers", "Pat Barnes", "Joe Kapp"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "Who holds the Cal record for most career rushing yards?",
            answers: ["Marshawn Lynch", "Russell White", "J.J. Arrington", "Chuck Muncie"],
            correctAnswer: 1,
            difficulty: .hard,
            category: .records
        ),

        TriviaQuestion(
            question: "What is the highest AP Poll ranking Cal has ever achieved?",
            answers: ["#2", "#3", "#4", "#5"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "Which Cal team had an undefeated season?",
            answers: ["1920", "1937", "1950", "2004"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "What is the capacity of California Memorial Stadium after renovation?",
            answers: ["62,467", "63,186", "64,796", "70,000"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .records
        ),

        TriviaQuestion(
            question: "Cal’s highest-scoring game came against which opponent?",
            answers: ["UC Davis", "San Jose State", "Pacific", "Stanford"],
            correctAnswer: 2,
            difficulty: .hard,
            category: .records
        ),

        TriviaQuestion(
            question: "Who holds Cal’s record for most interceptions in a single season?",
            answers: ["Deltha O’Neal", "Daymeion Hughes", "Nnamdi Asomugha", "Cameron Goode"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .records
        ),

        TriviaQuestion(
            question: "Which Cal player has the most career sacks?",
            answers: ["Cameron Jordan", "Andre Carter", "Ron Rivera", "Mychal Kendricks"],
            correctAnswer: 1,
            difficulty: .hard,
            category: .records
        ),
        TriviaQuestion(
            question: "What is the annual Cal vs. Stanford football game called?",
            answers: ["The Big Game", "The Golden Bowl", "The NorCal Classic", "The Bay Rivalry"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "What trophy is awarded to the winner of the Cal-Stanford game?",
            answers: ["The Axe", "The Bell", "The Cup", "The Trophy"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "‘The Play’ occurred during which year’s Big Game?",
            answers: ["1978", "1980", "1982", "1984"],
            correctAnswer: 2,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Who was the Cal player who scored the winning touchdown in ‘The Play’?",
            answers: ["Kevin Moen", "Richard Rodgers Sr.", "Mariet Ford", "Dwight Garner"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Which team is Cal’s traditional non-Stanford rival within the Pac-12 North?",
            answers: ["Oregon", "UCLA", "USC", "Washington"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Which marching band infamously ran onto the field during ‘The Play’?",
            answers: ["Stanford Band", "Cal Band", "USC Band", "Oregon Band"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Where is ‘The Big Game’ usually alternated between?",
            answers: ["Berkeley and Palo Alto", "Berkeley and San Francisco", "Palo Alto and San Jose", "San Francisco and Sacramento"],
            correctAnswer: 0,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Which rivalry game is sometimes called the ‘Battle of the Bay’?",
            answers: ["Cal vs. Stanford", "Cal vs. USC", "Cal vs. Oregon", "Stanford vs. USC"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Cal fans chant ‘Go Bears!’ while Stanford fans respond with what?",
            answers: ["Go Trees", "Go Cardinal", "Fear the Tree", "Fight On"],
            correctAnswer: 1,
            difficulty: .easy,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Which Cal coach famously said, 'The band is on the field!' during ‘The Play’?",
            answers: ["Joe Starkey", "Jeff Tedford", "Andy Smith", "Stub Allison"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "In which stadium did the 1982 Big Game take place?",
            answers: ["California Memorial Stadium", "Stanford Stadium", "Kezar Stadium", "Candlestick Park"],
            correctAnswer: 1,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "Which Cal team ended Stanford’s 7-game winning streak in 2002?",
            answers: ["Jeff Tedford’s Bears", "Tom Holmoe’s Bears", "Sonny Dykes’ Bears", "Mike White’s Bears"],
            correctAnswer: 0,
            difficulty: .medium,
            category: .rivals
        ),

        TriviaQuestion(
            question: "What is the Cal student section traditionally called?",
            answers: ["The Blue Zone", "The Cal Crew", "The Mic Men", "The Rally Committee"],
            correctAnswer: 3,
            difficulty: .hard,
            category: .rivals
        ),

    ]
    
    static func getRandomQuestions(count: Int = 5) -> [TriviaQuestion] {
        return Array(questions.shuffled().prefix(count))
    }
}

// MARK: - Ball Knowledge View

struct BallKnowledgeView: View {
    @StateObject private var triviaManager = TriviaManager()
    @State private var showingTrivia = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#0D1117").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerView
                        statsCard
                        triviaGameCard
                        comingSoonGames
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingTrivia) {
                TriviaGameView(triviaManager: triviaManager)
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text("explore")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Circle()
                        .fill(Color(hex: "#FDB515"))
                        .frame(width: 10, height: 10)
                }
                
                Text("test your ball knowledge")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.bottom, 4)
    }
    
    private var statsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Stats")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 12) {
                StatBox(
                    title: "Accuracy",
                    value: String(format: "%.0f%%", triviaManager.accuracy),
                    icon: "target"
                )
                
                StatBox(
                    title: "Current Streak",
                    value: "\(triviaManager.score.streak)",
                    icon: "flame.fill"
                )
                
                StatBox(
                    title: "Best Streak",
                    value: "\(triviaManager.score.bestStreak)",
                    icon: "trophy.fill"
                )
            }
        }
    }
    
    private var triviaGameCard: some View {
        Button(action: {
            hapticFeedback(.medium)
            showingTrivia = true
        }) {
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#003262"), Color(hex: "#3B7EA1")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(hex: "#FDB515"))
                        
                        Text("Cal Football Trivia")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#FDB515"))
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Start New Game")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(triviaManager.score.totalCorrect)/\(triviaManager.score.totalAttempted) questions answered correctly")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
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
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var comingSoonGames: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Coming Soon")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ComingSoonCard(
                    title: "Prediction League",
                    description: "Predict game outcomes and compete",
                    icon: "crystal.ball"
                )
                
                ComingSoonCard(
                    title: "Player Stats Quiz",
                    description: "Guess player statistics",
                    icon: "chart.bar.fill"
                )
                
                ComingSoonCard(
                    title: "Historic Moments",
                    description: "Match plays to their years",
                    icon: "clock.fill"
                )
            }
        }
    }
}

// MARK: - Trivia Game View

struct TriviaGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var triviaManager: TriviaManager
    
    @State private var questions: [TriviaQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var gameComplete = false
    @State private var sessionCorrect = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D1117").ignoresSafeArea()
            
            if gameComplete {
                resultsView
            } else {
                VStack(spacing: 0) {
                    topBar
                    
                    if !questions.isEmpty {
                        questionView
                    }
                }
            }
        }
        .onAppear {
            questions = TriviaDatabase.getRandomQuestions(count: 5)
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Exit")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(Color(hex: "#FDB515"))
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color(hex: "#FDB515"))
                Text("\(triviaManager.score.streak)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color(hex: "#161B22"))
            )
        }
        .padding()
    }
    
    private var questionView: some View {
        let question = questions[currentQuestionIndex]
        
        return VStack(spacing: 32) {
            // Progress
            VStack(spacing: 12) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1)/\(questions.count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Text(question.difficulty.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(difficultyColor(question.difficulty))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(difficultyColor(question.difficulty).opacity(0.2))
                        )
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#FDB515"), Color(hex: "#F2A900")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count))
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Question
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: categoryIcon(question.category))
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(Color(hex: "#FDB515"))
                    
                    Text(question.question)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // Answers
                VStack(spacing: 12) {
                    ForEach(0..<question.answers.count, id: \.self) { index in
                        answerButton(
                            text: question.answers[index],
                            index: index,
                            isCorrect: index == question.correctAnswer
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            if showingResult {
                Button(action: nextQuestion) {
                    Text(currentQuestionIndex < questions.count - 1 ? "Next Question" : "See Results")
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
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    private func answerButton(text: String, index: Int, isCorrect: Bool) -> some View {
        Button(action: {
            guard selectedAnswer == nil else { return }
            selectAnswer(index, isCorrect: isCorrect)
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showingResult {
                    if selectedAnswer == index {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? Color(hex: "#00FF87") : .red)
                    } else if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "#00FF87"))
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor(for: index, isCorrect: isCorrect))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(borderColor(for: index, isCorrect: isCorrect), lineWidth: 2)
                    )
            )
        }
        .disabled(showingResult)
    }
    
    private func backgroundColor(for index: Int, isCorrect: Bool) -> Color {
        guard showingResult, let selected = selectedAnswer else {
            return Color(hex: "#161B22")
        }
        
        if selected == index {
            return isCorrect ? Color(hex: "#00FF87").opacity(0.2) : Color.red.opacity(0.2)
        } else if isCorrect {
            return Color(hex: "#00FF87").opacity(0.1)
        }
        
        return Color(hex: "#161B22")
    }
    
    private func borderColor(for index: Int, isCorrect: Bool) -> Color {
        guard showingResult, let selected = selectedAnswer else {
            return Color.white.opacity(0.1)
        }
        
        if selected == index {
            return isCorrect ? Color(hex: "#00FF87") : .red
        } else if isCorrect {
            return Color(hex: "#00FF87")
        }
        
        return Color.white.opacity(0.1)
    }
    
    private func selectAnswer(_ index: Int, isCorrect: Bool) {
        hapticFeedback(isCorrect ? .heavy : .rigid)
        selectedAnswer = index
        self.isCorrect = isCorrect
        
        triviaManager.answerQuestion(correct: isCorrect)
        if isCorrect {
            sessionCorrect += 1
        }
        
        withAnimation(.spring(response: 0.3)) {
            showingResult = true
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showingResult = false
            }
        } else {
            withAnimation {
                gameComplete = true
            }
        }
    }
    
    private var resultsView: some View {
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
                    
                    Image(systemName: resultIcon)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Color(hex: "#FDB515"))
                }
                
                Text(resultTitle)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("You got \(sessionCorrect) out of \(questions.count) correct!")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                ResultRow(label: "Accuracy", value: String(format: "%.0f%%", triviaManager.accuracy))
                ResultRow(label: "Current Streak", value: "\(triviaManager.score.streak)")
                ResultRow(label: "Best Streak", value: "\(triviaManager.score.bestStreak)")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#161B22"))
            )
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: {
                    gameComplete = false
                    currentQuestionIndex = 0
                    selectedAnswer = nil
                    showingResult = false
                    sessionCorrect = 0
                    questions = TriviaDatabase.getRandomQuestions(count: 5)
                }) {
                    Text("Play Again")
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
                
                Button(action: { dismiss() }) {
                    Text("Back to Explore")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#161B22"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    private var resultIcon: String {
        let percentage = Double(sessionCorrect) / Double(questions.count)
        if percentage >= 0.8 { return "star.fill" }
        if percentage >= 0.6 { return "hand.thumbsup.fill" }
        return "arrow.clockwise"
    }
    
    private var resultTitle: String {
        let percentage = Double(sessionCorrect) / Double(questions.count)
        if percentage == 1.0 { return "Perfect!" }
        if percentage >= 0.8 { return "Excellent!" }
        if percentage >= 0.6 { return "Good Job!" }
        return "Keep Trying!"
    }
    
    private func categoryIcon(_ category: TriviaQuestion.Category) -> String {
        switch category {
        case .history: return "book.fill"
        case .players: return "person.fill"
        case .records: return "chart.bar.fill"
        case .rivals: return "flag.fill"
        }
    }
    
    private func difficultyColor(_ difficulty: TriviaQuestion.Difficulty) -> Color {
        switch difficulty {
        case .easy: return Color(hex: "#00FF87")
        case .medium: return Color(hex: "#FDB515")
        case .hard: return .red
        }
    }
}



// MARK: - Supporting Views

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(hex: "#FDB515"))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#161B22"))
        )
    }
}

struct ComingSoonCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#161B22"))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Text("Soon")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white.opacity(0.4))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.05))
                )
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
}

struct ResultRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
