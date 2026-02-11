import SwiftUI
import WorkoutPlannerCore

struct AlternativeSwipeStrip: View {
    let alternatives: [Exercise]
    let onSelect: (Exercise) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Can't do this one? Swipe and switch")
                .font(.footnote)
                .foregroundStyle(.secondary)

            TabView {
                ForEach(alternatives) { exercise in
                    Button {
                        onSelect(exercise)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline)
                            Text("\(exercise.primaryMuscle.capitalized) · \(exercise.equipment)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
            }
            .frame(height: 120)
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}
