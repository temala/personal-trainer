import Foundation
import WorkoutPlannerCore

protocol WorkoutStorage {
    func save(sessionState: WorkoutSessionState)
    func loadSessionState() -> WorkoutSessionState?
    func loadPerformanceRecords() -> [PerformanceRecord]
}

final class LocalWorkoutStorage: WorkoutStorage {
    private let defaults = UserDefaults.standard
    private let sessionKey = "workout.session.state"

    func save(sessionState: WorkoutSessionState) {
        let payload = SessionPayload(
            plan: sessionState.plan,
            completedExerciseIDs: sessionState.completedExerciseIDs,
            maxKgByExerciseID: sessionState.maxKgByExerciseID
        )

        if let data = try? JSONEncoder().encode(payload) {
            defaults.set(data, forKey: sessionKey)
        }
    }

    func loadSessionState() -> WorkoutSessionState? {
        guard let data = defaults.data(forKey: sessionKey),
              let payload = try? JSONDecoder().decode(SessionPayload.self, from: data) else {
            return nil
        }
        return WorkoutSessionState(
            plan: payload.plan,
            completedExerciseIDs: payload.completedExerciseIDs,
            maxKgByExerciseID: payload.maxKgByExerciseID
        )
    }

    func loadPerformanceRecords() -> [PerformanceRecord] {
        let state = loadSessionState()
        let records = state?.maxKgByExerciseID.map { PerformanceRecord(exerciseID: $0.key, maxKg: $0.value) }
        return records ?? []
    }
}

private struct SessionPayload: Codable {
    let plan: WorkoutPlan
    let completedExerciseIDs: [Int]
    let maxKgByExerciseID: [Int: Double]
}
