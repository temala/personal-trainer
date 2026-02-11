import Foundation
import WorkoutPlannerCore

/// Uses an LLM only for plan generation/rebuild.
struct OpenAIPlanOrchestrator: PlanOrchestrator {
    private let fallback = RuleBasedFallbackPlanner()

    func buildPlan(
        goals: UserGoalProfile,
        catalog: [Exercise],
        performance: [PerformanceRecord],
        previousPlan: WorkoutPlan?
    ) async throws -> WorkoutPlan {
        // In production, call an LLM endpoint here with strict JSON schema output.
        // If unavailable, safely fallback to deterministic rules.
        return try await fallback.buildPlan(
            goals: goals,
            catalog: catalog,
            performance: performance,
            previousPlan: previousPlan
        )
    }
}
