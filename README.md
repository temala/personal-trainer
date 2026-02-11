# Native iOS Workout Planner (No Login)

This repository now contains a **native iOS-first architecture** for a frictionless workout planner.

## Product intent
- Open app → immediately see the next exercise to perform.
- No login, no onboarding wall.
- Track completed exercises and personal records (max kg by exercise).
- Swipe to quickly replace an exercise if equipment is occupied or disliked.
- Build-muscle + lose-weight baseline, with custom preference tuning (more chest, less/no legs, optional cardio target like resting 55 bpm).
- LLM is used **only** when creating/rebuilding the plan.
- Exercise catalog and images are loaded from a real external API (Wger).

## Structure
- `ios-native-app/`: SwiftUI app scaffold (native iOS UI and app flow).
- `Package.swift` + `Sources/WorkoutPlannerCore`: testable planning engine and models.
- `Tests/WorkoutPlannerCoreTests`: plan generation behavior tests.

## Chosen external exercise API
- **Wger API**: `https://wger.de/api/v2/exerciseinfo/`
- Why: public API, rich exercise metadata, supports exercise images.

## LLM orchestration model
The app calls an LLM provider only when generating a new plan from:
- user goals,
- available exercise catalog,
- recent completion history,
- PR/max weight history.

Generated plan is persisted locally and executed offline during workout sessions.

## How to build/run
For a complete beginner-friendly setup and run guide, see `RUN_IOS.md`.
