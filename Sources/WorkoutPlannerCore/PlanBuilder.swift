import Foundation

public protocol PlanOrchestrator {
    func buildPlan(
        goals: UserGoalProfile,
        catalog: [Exercise],
        performance: [PerformanceRecord],
        previousPlan: WorkoutPlan?
    ) async throws -> WorkoutPlan
}

public struct RuleBasedFallbackPlanner: PlanOrchestrator {
    public init() {}

    public func buildPlan(
        goals: UserGoalProfile,
        catalog: [Exercise],
        performance: [PerformanceRecord],
        previousPlan: WorkoutPlan?
    ) async throws -> WorkoutPlan {
        let filtered = catalog.filter { !goals.excludedMuscles.contains($0.primaryMuscle.lowercased()) }
        let sorted = filtered.sorted { lhs, rhs in
            score(for: lhs, goals: goals) > score(for: rhs, goals: goals)
        }

        let selected = Array(sorted.prefix(8))
        let queue = selected.enumerated().map { idx, exercise in
            let alternatives = sorted.filter {
                $0.primaryMuscle == exercise.primaryMuscle && $0.id != exercise.id
            }
            return PlanExercise(
                id: idx,
                exercise: exercise,
                sets: 4,
                repRange: 8...12,
                alternatives: Array(alternatives.prefix(3))
            )
        }

        return WorkoutPlan(createdAt: Date(), queue: queue)
    }

    private func score(for exercise: Exercise, goals: UserGoalProfile) -> Int {
        let muscle = exercise.primaryMuscle.lowercased()
        if goals.focusMuscles.contains(muscle) { return 10 }
        if goals.reducedMuscles.contains(muscle) { return 2 }
        return 5
    }
}
