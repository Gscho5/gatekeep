
# Gatekeep

> A 2-minute personalized briefing for UC Berkeley football fans. built as a venture experiment to test whether casual Cal fans would pay attention to a tailored daily feed instead of doomscrolling ESPN.

**Gatekeep** was a product-validation experiment: could we get students, alums, parents, and casual local fans to engage with Cal football daily if the content was tuned to their tone, attention span, and connection to the team?

We built a working iOS prototype, ran it through the validation loop, learned what we needed to learn, and shipped this repo as a record of the attempt.


---

## What It Does

- **5-step onboarding** that profiles your fandom on four axes: connection to Cal, reading length (30s / 2min / 5min), content priorities (game outcomes, player stats, injuries, standings, recruiting, history), and tone style (professional / casual / hype / just-the-facts).
- **Personalized briefings feed** powered by the ESPN college-football API — live scores, schedules, ACC conference rank, and pre-game **Gatekeep** + **Postgame** recap cards.
- **Smart 24-hour caching** that re-fetches only when game IDs change, so the app stays fast and respects ESPN's rate limits.
- **Ball Knowledge trivia** — Cal-football trivia game with streak tracking, accuracy stats, and four categories (History, Players, Records, Rivals).
- **Cal-branded design system** — Berkeley Blue (`#003262`) and California Gold (`#FDB515`), dark-mode-first.
- **Zero dependencies, zero backend, zero accounts.** Everything runs on-device.

---

## Architecture

Lightweight MVVM-style SwiftUI app, single Xcode target, no third-party packages.

```
gatekeep/
├── GatekeepApp.swift          # @main entry point
├── Views/
│   ├── ContentView.swift      # Root router: onboarding vs. main tab view
│   ├── OnboardingViews.swift  # 5-step onboarding flow
│   ├── BriefingsView.swift    # "Feed" tab — briefings & season overview
│   ├── BallKnowledgeView.swift# "Explore" tab — trivia game
│   └── SupportingViews.swift  # Shared UI components
├── Models/
│   ├── UserProfile.swift      # User profile + FanType/ReadingLength/Tone enums
│   ├── BriefingModels.swift   # BriefingCard, BriefingType
│   ├── TeamStats.swift        # TeamStats, GameData, CachedData
│   └── ESPNModels.swift       # Codable structs for ESPN API responses
├── Managers/
│   ├── ProfileManager.swift   # Singleton — user profile persistence
│   └── CacheManager.swift     # Singleton — 24h smart-refresh data cache
└── Utilities/
    └── Extensions.swift       # Color(hex:), haptic helpers, ScaleButtonStyle
```

**Key design decisions:**

- **Singletons over Core Data** for persistence — the data model is small (one profile, one cached dataset), so `UserDefaults` + `Codable` was the right tradeoff for prototype speed.
- **Cache invalidation keyed on game IDs**, not just timestamps — the feed refreshes the moment a new game completes, rather than on an arbitrary schedule. Cuts unnecessary API calls dramatically.
- **No backend, no auth, no third-party SDKs.** This was deliberate: it kept the validation cycle short and meant we collected zero user data while testing.

---

## Tech Stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI (iOS 17+)
- **Networking:** `URLSession` + `async/await`
- **Persistence:** `UserDefaults` + `Codable`
- **External API:** [ESPN College Football API](https://site.api.espn.com/apis/site/v2/sports/football/college-football/) (public, unauthenticated)

---

## Run It Yourself

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ simulator or device

### Setup
```bash
git clone https://github.com/Gscho5/gatekeep.git
cd gatekeep
open Gatekeep.xcodeproj
```
Then ⌘R in Xcode. No API keys or environment setup required.

---

## Screenshots

### Feed — personalized briefings powered by the ESPN API

The home tab pulls live Cal football data, computes record + conference standings, and surfaces AI-style briefing cards tailored to the user's onboarding choices.

<p align="center">
  <img src="screenshots/01-feed.png" alt="Main feed with season overview" width="240"/>
</p>

### Explore — Cal Football trivia with streak tracking

The Explore tab is a multiple-choice trivia game over real Cal football history, with difficulty tiers, live streak counters, and persistent best-streak / accuracy stats.

<p align="center">
  <img src="screenshots/04-explore.png" alt="Explore tab home with stats" width="240"/>
  <img src="screenshots/05-trivia-hard.png" alt="Hard trivia question" width="240"/>
  <img src="screenshots/06-trivia-medium.png" alt="Medium trivia question" width="240"/>
</p>

<p align="center">
  <img src="screenshots/07-trivia-review.png" alt="Answer review showing correct vs incorrect" width="240"/>
  <img src="screenshots/08-quiz-results.png" alt="End-of-quiz results screen" width="240"/>
</p>

---

## What We Learned

**On the product side:**
- The 4-axis fan-profile framework (connection × reading length × content priorities × tone) generalizes well — there's genuine appetite at UC Berkeley for a tailored briefing instead of generic ESPN/Twitter scrolling, across students, alums, and casual fans alike.
- The format is replicable. A "Gatekeep for [X]" applied to other Power 4 / Big Ten programs, the NFL, college basketball, MLB, and so on is a real product wedge — sports fandom is segmented by team, and personalization-by-fandom is underserved everywhere we looked.

**On the technical side:**
- ESPN's free public API was the right call for a prototype but is the wrong foundation for a real product. Coverage gaps, occasional staleness, and lack of granular player/play-by-play data limit what we could analyze. A production version would need a paid sports data feed (SportRadar, Sportradar, or a wrapped provider) for accuracy.
- `UserDefaults` + smart cache invalidation was the right tradeoff for a single-user prototype, but it would not scale. A real version needs a proper backend, identity, and a server-side aggregation layer that fans out one set of API calls across all users instead of every device hitting the API directly.
- Singletons (`ProfileManager.shared`, `CacheManager.shared`) sped up the prototype but would be the first thing to refactor toward dependency injection if we kept going.
- SwiftUI's `@StateObject` + `@Published` reactivity made the onboarding flow trivially easy — the same UI in UIKit would have been roughly 3× the code.

**On the venture side:**
- **API costs are the central unit-economics question.** A consumer sports app has to fund every game's data fetches against very low per-user revenue. Without an ad strategy, a subscription tier, or a B2B angle (e.g., licensing to athletic departments), the business model doesn't pencil out at zero scale.
- We validated demand but couldn't simultaneously solve data quality + data funding as unfunded freshmen. That's the structural reason we paused — not lack of interest in the product, but lack of a path to keep the lights on while we grew it.
- If we revisit Gatekeep, the right v2 is probably to pitch it to one or two athletic department comms offices first (B2B2C) rather than launching free on the App Store.

---

## Status

**Paused, not abandoned.** We validated the core hypothesis — there's a real market at UC Berkeley, and the format scales naturally to other colleges, the NFL, and other sports — but identified two structural blockers we couldn't solve as freshmen without funding: data accuracy (the free ESPN API isn't enough for a production product) and API cost coverage (no business model that pencils out at zero scale).

So this repo is preserved as documentation of the build and the lessons. If we revisit Gatekeep, v2 starts with a paid data provider and a B2B2C pitch to athletic department comms offices.

If you want to fork it and take it further — go for it. The MIT license below covers it.

---

## Authors

Built by **Gabe Schoor** ([@Gscho5](https://github.com/Gscho5)) and **Snehan Majumder** ([@snehanmajumder](https://github.com/snehanmajumder)).

Gabe Schoor — Industrial Engineering & Operations Research, UC Berkeley '29
[GitHub](https://github.com/Gscho5) · [LinkedIn](#) <!-- TODO: add LinkedIn -->

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- ESPN for the open college-football data API
- Everyone who tried the prototype and gave us feedback
- Go Bears 🐻💙💛
