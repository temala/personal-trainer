import SwiftUI

@main
struct WorkoutPlannerApp: App {
    @StateObject private var viewModel = WorkoutSessionViewModel(
        catalogClient: WgerExerciseCatalogClient(),
        planOrchestrator: OpenAIPlanOrchestrator(),
        storage: LocalWorkoutStorage()
    )

    var body: some Scene {
        WindowGroup {
            CurrentExerciseView(viewModel: viewModel)
        }
    }
}
