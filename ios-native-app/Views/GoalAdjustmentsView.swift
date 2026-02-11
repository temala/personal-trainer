import SwiftUI

struct GoalAdjustmentsView: View {
    @ObservedObject var viewModel: WorkoutSessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var focusInput = "chest"
    @State private var reducedInput = "legs"
    @State private var excludedInput = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Focus muscles (comma separated)", text: $focusInput)
                TextField("Reduced muscles", text: $reducedInput)
                TextField("Excluded muscles", text: $excludedInput)
                Toggle("Include cardio", isOn: Binding(
                    get: { viewModel.goals.cardioEnabled },
                    set: { viewModel.goals.cardioEnabled = $0 }
                ))
                Stepper(
                    "Resting HR target: \(viewModel.goals.restingHeartRateTarget ?? 55) bpm",
                    value: Binding(
                        get: { viewModel.goals.restingHeartRateTarget ?? 55 },
                        set: { viewModel.goals.restingHeartRateTarget = $0 }
                    ),
                    in: 45...70
                )
            }
            .navigationTitle("Plan Goals")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.goals.focusMuscles = parse(input: focusInput)
                        viewModel.goals.reducedMuscles = parse(input: reducedInput)
                        viewModel.goals.excludedMuscles = parse(input: excludedInput)
                        Task { await viewModel.regeneratePlan() }
                        dismiss()
                    }
                }
            }
        }
    }

    private func parse(input: String) -> [String] {
        input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
    }
}
