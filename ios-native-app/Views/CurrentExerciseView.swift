import SwiftUI
import WorkoutPlannerCore

struct CurrentExerciseView: View {
    @ObservedObject var viewModel: WorkoutSessionViewModel
    @State private var usedKgText = ""
    @State private var showingGoals = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Building your plan...")
                } else if let exercise = viewModel.currentExercise {
                    VStack(spacing: 20) {
                        ExerciseCard(exercise: exercise.exercise)

                        Text("\(exercise.sets) sets · \(exercise.repRange.lowerBound)-\(exercise.repRange.upperBound) reps")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Weight used (kg)", text: $usedKgText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)

                        Button("Complete exercise") {
                            viewModel.completeCurrentExercise(kg: Double(usedKgText) ?? 0)
                            usedKgText = ""
                        }
                        .buttonStyle(.borderedProminent)

                        AlternativeSwipeStrip(alternatives: exercise.alternatives) { replacement in
                            viewModel.swapCurrentExercise(with: replacement)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("You finished today's queue 🎉")
                        Button("Regenerate plan") {
                            Task { await viewModel.regeneratePlan() }
                        }
                    }
                }
            }
            .navigationTitle("Next Exercise")
            .toolbar {
                Button("Goals") { showingGoals = true }
            }
            .sheet(isPresented: $showingGoals) {
                GoalAdjustmentsView(viewModel: viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            })
        }
    }
}

private struct ExerciseCard: View {
    let exercise: Exercise

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: exercise.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(exercise.name)
                .font(.title3.bold())
            Text("\(exercise.primaryMuscle.capitalized) · \(exercise.equipment)")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
