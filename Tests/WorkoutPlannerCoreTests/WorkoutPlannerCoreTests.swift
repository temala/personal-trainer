import Testing
@testable import WorkoutPlannerCore

struct WorkoutPlannerCoreTests {
    @Test
    func excludesForbiddenMuscleGroupsFromPlan() async throws {
        let planner = RuleBasedFallbackPlanner()
        let catalog = [
            Exercise(id: 1, name: "Bench Press", primaryMuscle: "chest", equipment: "barbell", imageURL: nil),
            Exercise(id: 2, name: "Back Squat", primaryMuscle: "legs", equipment: "barbell", imageURL: nil),
            Exercise(id: 3, name: "Seated Row", primaryMuscle: "back", equipment: "machine", imageURL: nil)
        ]

        let goals = UserGoalProfile(
            focusMuscles: ["chest"],
            reducedMuscles: [],
            excludedMuscles: ["legs"],
            cardioEnabled: false,
            restingHeartRateTarget: nil
        )

        let plan = try await planner.buildPlan(goals: goals, catalog: catalog, performance: [], previousPlan: nil)

        #expect(plan.queue.contains(where: { $0.exercise.primaryMuscle == "legs" }) == false)
        #expect(plan.queue.first?.exercise.primaryMuscle == "chest")
    }

    @Test
    func tracksMaxKgAndMovesToNextExercise() {
        var session = WorkoutSessionState(
            plan: WorkoutPlan(
                createdAt: .now,
                queue: [
                    PlanExercise(
                        id: 0,
                        exercise: Exercise(id: 11, name: "Incline Press", primaryMuscle: "chest", equipment: "dumbbell", imageURL: nil),
                        sets: 4,
                        repRange: 8...12,
                        alternatives: []
                    ),
                    PlanExercise(
                        id: 1,
                        exercise: Exercise(id: 12, name: "Lat Pulldown", primaryMuscle: "back", equipment: "machine", imageURL: nil),
                        sets: 4,
                        repRange: 8...12,
                        alternatives: []
                    )
                ]
            )
        )

        session.complete(exerciseID: 11, usedKg: 45)
        session.complete(exerciseID: 11, usedKg: 42)

        #expect(session.maxKgByExerciseID[11] == 45)
        #expect(session.nextExercise?.exercise.id == 12)
    }
}
