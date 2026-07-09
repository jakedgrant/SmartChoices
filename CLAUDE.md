# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Smart Choices (Xcode project/product name "obey") is an iOS + watchOS app that lets a parent reward one or more children for making good choices. Tapping "Smart Choice" either rolls for a random reward (surprise mode) or earns a star toward a reward of the child's choosing (stars mode). It uses SwiftUI, SwiftData, CloudKit sync, RevenueCat for paid unlocks, and App Intents/Siri Shortcuts.

## Build, run, and test

A `Makefile` wraps `xcodebuild` for the `obey` scheme/iOS Simulator:

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

The `obey with StoreKit` scheme runs against the local `Smart Choices.storekit` configuration instead of hitting App Store Connect/RevenueCat sandbox — prefer it when testing purchase flows. There's also a separate `obeyWatch Watch App` scheme/target for the watch app.

`obey/Model/Secrets.swift` holds the RevenueCat public API key and is checked into git (the `.gitignore` entry for it is commented out) — this is intentional since it's a client-embeddable public key, not a server secret.

## Architecture

### Data model and persistence

Three SwiftData models back the app, all included in the app's shared `ModelContainer` (wired in `obeyApp.swift`):
- `SDUser` — a child profile: display name, `StandardColor`, and per-child state for both reward modes (`odds`/`losses` for surprise mode, `starBalance` for stars mode). Owns `rewards` and `logs` via nullify-delete relationships.
- `SDReward` — a reward a child can win/redeem, with a `starCost` used only in stars mode. Optionally scoped to specific users via `SDUser.rewards`; an unscoped reward is available to everyone.
- `SDLog` — a history entry recording either a surprise-mode roll (`odds`/`losses`/`increasedOdds`) or a stars-mode redemption (`starsSpent`/`starBalance`), linked to the `SDReward` and `SDUser` via nullify-delete relationships.

Data access goes through a small protocol stack rather than raw `ModelContext` calls in views:
- `Database` (`Model/DB/Database.swift`) declares CRUD + count operations generically over an associated type.
- `SwiftDatabase` (`Model/DB/SwiftDatabase.swift`) implements `Database` for any SwiftData `PersistentModel` using a `ModelContainer`.
- `RewardDatabase`, `LogDatabase`, and `UserDatabase` (`Model/DB/`) each own their own `ModelContainer` for one model type and add query helpers (`activeRewards()`, `logs(for:)`, `users(with:)`, etc). These are the classes used from non-SwiftUI contexts (App Intents, migration code) where `@Query`/`@Environment(\.modelContext)` aren't available.

SwiftUI views instead use `@Query`/`@Environment(\.modelContext)` directly against the shared container (see `ContentView`, `RedeemRewardsView`, `MultiUserMigrationView`).

### Multi-user model

`SelectedUserManager.shared` tracks which `SDUser` is currently active, persisting the choice by UUID in shared `UserDefaults` and re-resolving it against the store on launch (`ensureSelectedUser(context:)`), falling back to the first user alphabetically or creating one ("New Kid") if the store is empty. `ContentView` and the watch app both read this shared singleton, and `obeyApp.swift` derives the app's `themeColor` environment value from `selectedUserManager.selectedUser?.swiftUIColor`.

Reward-mode mechanics live on `SDUser` itself once a user exists: `Roll.perform(for:)` reads/writes `user.odds`/`user.losses`, and `StarBank`'s per-user methods (`extension SDUser` in `Helpers/StarBank.swift`) read/write `user.starBalance`. The old shared-`UserDefaults`-backed `Roll.perform()` and `StarBank` static methods still exist as a fallback for the rare case of no user existing yet (e.g. an intent firing before setup completes).

### Reward modes

`RewardMode` (surprise vs. stars) is the central branch point for app behavior, persisted as a raw string in shared `UserDefaults` (app group `group.com.jacobgrant.obey`, so it's readable from the watch app and App Intents extension):
- **Surprise mode**: a "pity timer" — odds start at `Constants.startingOdds`, increase by 1 (capped at `maxOdds`) after every win, and a loss streak reaching current odds forces a win.
- **Stars mode**: earning always adds `Constants.starsPerChoice`; spending is validated against `canAfford`/`SDReward.starCost`.

Both `ContentView` (iOS) and the watch app's `ContentView` independently read the same `@AppStorage` keys against the shared suite, so the two targets are kept in sync by CloudKit + shared defaults rather than any direct communication — check both when changing reward-mode logic.

### First-run / migration flow

Two migrations run before views can read state, in this order from `obeyApp.swift`:
1. `RewardModelMigrator.migrateIfNeeded()` — brings pre-reward-mode installs (`RewardModelMigrator.currentVersion` bump) forward: existing users are pinned to surprise mode, reward setup is marked complete, and their star balance is seeded from accumulated `losses` in shared defaults.
2. `MultiUserMigrationView`, shown from `ContentView` when `userMigrationCompleted` is false — walks the parent through creating the first `SDUser` and carries the pre-multi-user star balance (`StarBank.balance`) onto that new user. The same view also drives brand-new-install onboarding (`.onboarding` flow, gated on `previousVersionString == Constants.startingVersion`) and the "add another child" flow (`.addUser`, launched from `ManageUsersView`) — the `Flow` enum picks which steps are shown.

`hasCompletedRewardSetupKey` gates the reward-setup step; `ContentView.populateRewards()` is only a safety net for an emptied store, not the primary seeding path.

### Release notes / recap screens

`ObeyRecap.swift` builds on the `Recap` package to show "what's new" screens, driven by markdown files bundled in the app: `obey/Releases.md` (update notes per version, newest first) and `obey/Intro.md` (first-run intro). `ReleasePackage.display(for:with:)` compares semantic versions to decide whether to show onboarding, an update recap, or nothing — this logic is covered by `ObeyTests/ReleasePackageTests.swift`. When shipping a new version, add an entry to the top of `Releases.md` following the existing `title`/`description`/`symbol`/`color` format.

### App Intents / Siri

`Intents/RollForRewardIntent.swift` mirrors the in-app "Smart Choice" action for Siri/Shortcuts, taking an optional `UserEntity` parameter (falls back to `SelectedUserManager.shared.selectedUser`) and branching on `RewardMode.current` the same way `ContentView.makeSmartChoice()` does. It talks to `UserDatabase`/`RewardDatabase` directly (not `@Query`) since intents run outside SwiftUI. `RewardEntity`/`RewardQuery` and `UserEntity`/`UserQuery` expose `SDReward`/`SDUser` to App Intents via the shared `Displayable` protocol also used by the `Reward` enum (the hardcoded default reward set) and `CategoryDisplayable` (drives display/section names for `SDUser`/`SDReward`/`SDLog` across the intents and history UI).

### Monetization

RevenueCat (`Purchases` SDK) gates a "full unlock" behind either a subscription or one-time entitlement (`Constants.subscriptionEntitlementID`/`onetimeEntitlementID`). `UserViewModel.shared` is a singleton `ObservableObject` fed by `PurchasesDelegateHandler` whenever RevenueCat's cache updates; `unlockActive`/`isSubscriber` are derived from `customerInfo.entitlements.active` and are force-enabled under `#if DEBUG`.
