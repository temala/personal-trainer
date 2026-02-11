# iOS Native App Scaffold

This folder contains a SwiftUI scaffold for a no-login workout assistant.

## UX flow
1. App opens directly on **Next Exercise** screen.
2. User sees image, sets/reps, and can mark done quickly.
3. If exercise isn't possible, user swipes alternatives and taps one.
4. User adjusts goals in a lightweight modal and rebuilds plan.

## Notes
- `OpenAIPlanOrchestrator` is intentionally isolated so LLM calls happen only on plan generation.
- `WgerExerciseCatalogClient` provides exercise metadata + images from a public API.
- Persistence is local via `UserDefaults`; no auth required.
