# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Smart Choices (Xcode project/product name "obey") is an iOS + watchOS app that lets a parent reward a child for making good choices. Tapping "Smart Choice" either rolls for a random reward (surprise mode) or earns a star toward a reward of the child's choosing (stars mode). It uses SwiftUI, SwiftData, CloudKit sync, RevenueCat for paid unlocks, and App Intents/Siri Shortcuts.

## Build, run, and test

A `Makefile` (installed via the `xcode-makefiles` skill) wraps `xcodebuild` for the `obey` scheme/iOS Simulator:

```bash
make diagnose         # print toolchain/scheme/destination info
make build             # build the obey scheme for iOS Simulator
make test              # run ObeyTests (Swift Testing framework, not XCTest)
make run               # install + launch the last build on the simulator
make build-and-run     # build then run
make clean             # wipe derived data/logs for this agent
```

Builds are isolated under `build/` (DerivedData, logs, caches), keyed by `AGENT_NAME` (auto-resolved, override by exporting `AGENT_NAME`); `build/` and `agents/` are gitignored. Logs and `.xcresult` bundles land in `build/logs/<AGENT_NAME>/`.

Equivalent raw `xcodebuild` invocations still work directly, e.g.:

```bash
xcodebuild -list -project obey.xcodeproj
xcodebuild -project obey.xcodeproj -scheme obey -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:ObeyTests/ReleasePackageTests
```

Note: the Makefile's build/test recipes intentionally do **not** set `SWIFT_TREAT_WARNINGS_AS_ERRORS`/`GCC_TREAT_WARNINGS_AS_ERRORS` — the default xcode-makefiles template does, but that setting is applied to every target in the invocation, including the RevenueCat/Recap/ConfettiSwiftUI SPM dependency targets, which Xcode already builds with `-suppress-warnings`. Combining both flags on those targets fails with "Conflicting options" before a single line of app code compiles.

The `obey with StoreKit` scheme runs against the local `Smart Choices.storekit` configuration instead of hitting App Store Connect/RevenueCat sandbox — prefer it when testing purchase flows. There's also a separate `obeyWatch Watch App` scheme/target for the watch app.

`obey/Model/Secrets.swift` holds the RevenueCat public API key and is checked into git (the `.gitignore` entry for it is commented out) — this is intentional since it's a client-embeddable public key, not a server secret.

## Architecture

### Data model and persistence

Two SwiftData models back the app, both included in the app's shared `ModelContainer` (wired in `obeyApp.swift`):
- `SDReward` — a reward the child can win/redeem, with a `starCost` used only in stars mode.
- `SDLog` — a history entry recording either a surprise-mode roll (`odds`/`losses`/`increasedOdds`) or a stars-mode redemption (`starsSpent`/`starBalance`), linked to the `SDReward` via a nullify-delete relationship.

Data access goes through a small protocol stack rather than raw `ModelContext` calls in views:
- `Database` (`Model/DB/Database.swift`) declares CRUD + count operations generically over an associated type.
- `SwiftDatabase` (`Model/DB/SwiftDatabase.swift`) implements `Database` for any SwiftData `PersistentModel` using a `ModelContainer`.
- `RewardDatabase` and `LogDatabase` (`Model/DB/`) each own their own `ModelContainer` for `SDReward`/`SDLog` respectively and add query helpers (`activeRewards()`, `logs(for:)`, etc). These are the classes used from non-SwiftUI contexts (App Intents, migration code) where `@Query`/`@Environment(\.modelContext)` aren't available.

SwiftUI views instead use `@Query`/`@Environment(\.modelContext)` directly against the shared container (see `ContentView`, `RedeemRewardsView`, `OnboardingView`).

### Reward modes

`RewardMode` (surprise vs. stars) is the central branch point for app behavior, persisted as a raw string in shared `UserDefaults` (app group `group.com.jacobgrant.obey`, so it's readable from the watch app and App Intents extension):
- **Surprise mode**: `Roll.perform()` implements a "pity timer" — odds start at `Constants.startingOdds`, increase by 1 (capped at `maxOdds`) after every win, and a loss streak reaching current odds forces a win. State (`odds`/`losses`) lives in the same shared `UserDefaults`.
- **Stars mode**: `StarBank` reads/writes an integer star balance in shared `UserDefaults`; earning always adds `Constants.starsPerChoice`, spending is validated against `canAfford`/`SDReward.starCost`.

Both `ContentView` (iOS) and the watch app's `ContentView` independently read the same `@AppStorage` keys against the shared suite, so the two targets are kept in sync by CloudKit + shared defaults rather than any direct communication — check both when changing reward-mode logic.

### First-run / migration flow

`obeyApp.swift` runs `RewardModelMigrator.migrateIfNeeded()` before anything else touches shared defaults. It distinguishes:
- **Existing users** (had rewards or a stored `previousVersionString` before reward modes shipped) — pinned to surprise mode, reward setup marked complete, and their star balance is seeded from accumulated `losses` so switching modes later doesn't zero them out.
- **Fresh installs** — left alone so `OnboardingView` (mode + starting rewards picker) runs via `ContentView.presentOnboardingIfNeeded()`.

`hasCompletedRewardSetupKey` is the flag that gates onboarding; `ContentView.populateRewards()` is only a safety net for an emptied store, not the primary seeding path.

### Release notes / recap screens

`ObeyRecap.swift` builds on the `Recap` package to show "what's new" screens, driven by markdown files bundled in the app: `obey/Releases.md` (update notes per version, newest first) and `obey/Intro.md` (first-run intro). `ReleasePackage.display(for:with:)` compares semantic versions to decide whether to show onboarding, an update recap, or nothing — this logic is covered by `ObeyTests/ReleasePackageTests.swift`. When shipping a new version, add an entry to the top of `Releases.md` following the existing `title`/`description`/`symbol`/`color` format.

### App Intents / Siri

`Intents/RollForRewardIntent.swift` mirrors the in-app "Smart Choice" action for Siri/Shortcuts, branching on `RewardMode.current` the same way `ContentView.makeSmartChoice()` does. It talks to `RewardDatabase` directly (not `@Query`) since intents run outside SwiftUI. `RewardEntity`/`RewardQuery` expose `SDReward` to App Intents via the shared `Displayable` protocol also used by the `Reward` enum (the hardcoded default reward set).

### Monetization

RevenueCat (`Purchases` SDK) gates a "full unlock" behind either a subscription or one-time entitlement (`Constants.subscriptionEntitlementID`/`onetimeEntitlementID`). `UserViewModel.shared` is a singleton `ObservableObject` fed by `PurchasesDelegateHandler` whenever RevenueCat's cache updates; `unlockActive`/`isSubscriber` are derived from `customerInfo.entitlements.active` and are force-enabled under `#if DEBUG`.
