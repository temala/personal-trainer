import Foundation

public struct WorkoutSessionState: Equatable {
    public private(set) var plan: WorkoutPlan
    public private(set) var completedExerciseIDs: [Int]
    public private(set) var maxKgByExerciseID: [Int: Double]

    public init(plan: WorkoutPlan, completedExerciseIDs: [Int] = [], maxKgByExerciseID: [Int: Double] = [:]) {
        self.plan = plan
        self.completedExerciseIDs = completedExerciseIDs
        self.maxKgByExerciseID = maxKgByExerciseID
    }

    public var nextExercise: PlanExercise? {
        plan.queue.first { !completedExerciseIDs.contains($0.exercise.id) }
    }

    public mutating func complete(exerciseID: Int, usedKg: Double) {
        if !completedExerciseIDs.contains(exerciseID) {
            completedExerciseIDs.append(exerciseID)
        }
        let current = maxKgByExerciseID[exerciseID] ?? 0
        maxKgByExerciseID[exerciseID] = max(current, usedKg)
    }

    public mutating func swapCurrentExercise(with replacement: Exercise) {
        guard let next = nextExercise,
              let idx = plan.queue.firstIndex(where: { $0.id == next.id }) else { return }

        plan.queue[idx] = PlanExercise(
            id: next.id,
            exercise: replacement,
            sets: next.sets,
            repRange: next.repRange,
            alternatives: next.alternatives.filter { $0.id != replacement.id } + [next.exercise]
        )
    }
}
