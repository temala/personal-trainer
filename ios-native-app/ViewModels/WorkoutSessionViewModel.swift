import Foundation
import WorkoutPlannerCore

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var sessionState: WorkoutSessionState?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var goals = UserGoalProfile(
        focusMuscles: ["chest"],
        reducedMuscles: ["legs"],
        excludedMuscles: [],
        cardioEnabled: false,
        restingHeartRateTarget: 55
    )

    private let catalogClient: ExerciseCatalogClient
    private let planOrchestrator: PlanOrchestrator
    private let storage: WorkoutStorage

    init(catalogClient: ExerciseCatalogClient, planOrchestrator: PlanOrchestrator, storage: WorkoutStorage) {
        self.catalogClient = catalogClient
        self.planOrchestrator = planOrchestrator
        self.storage = storage
        sessionState = storage.loadSessionState()

        if sessionState == nil {
            Task { await regeneratePlan() }
        }
    }

    var currentExercise: PlanExercise? { sessionState?.nextExercise }

    func regeneratePlan() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let catalog = try await catalogClient.fetchExercises(limit: 200)
            let plan = try await planOrchestrator.buildPlan(
                goals: goals,
                catalog: catalog,
                performance: storage.loadPerformanceRecords(),
                previousPlan: sessionState?.plan
            )
            sessionState = WorkoutSessionState(plan: plan)
            persist()
        } catch {
            errorMessage = "Unable to build plan: \(error.localizedDescription)"
        }
    }

    func completeCurrentExercise(kg: Double) {
        guard let currentID = currentExercise?.exercise.id else { return }
        sessionState?.complete(exerciseID: currentID, usedKg: kg)
        persist()
    }

    func swapCurrentExercise(with replacement: Exercise) {
        sessionState?.swapCurrentExercise(with: replacement)
        persist()
    }

    private func persist() {
        guard let sessionState else { return }
        storage.save(sessionState: sessionState)
    }
}
