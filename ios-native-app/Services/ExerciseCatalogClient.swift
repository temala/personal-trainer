import Foundation
import WorkoutPlannerCore

protocol ExerciseCatalogClient {
    func fetchExercises(limit: Int) async throws -> [Exercise]
}

struct WgerExerciseCatalogClient: ExerciseCatalogClient {
    private let session: URLSession = .shared

    func fetchExercises(limit: Int) async throws -> [Exercise] {
        var components = URLComponents(string: "https://wger.de/api/v2/exerciseinfo/")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "2"),
            URLQueryItem(name: "limit", value: String(limit))
        ]

        let (data, _) = try await session.data(from: components.url!)
        let decoded = try JSONDecoder().decode(WgerResponse.self, from: data)
        return decoded.results.compactMap { item in
            let name = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { return nil }
            let muscle = item.category?.name.lowercased() ?? "full body"
            return Exercise(
                id: item.id,
                name: name,
                primaryMuscle: muscle,
                equipment: item.equipment.first?.name ?? "unknown",
                imageURL: item.images.first?.image
            )
        }
    }
}

private struct WgerResponse: Decodable {
    let results: [WgerExercise]
}

private struct WgerExercise: Decodable {
    let id: Int
    let name: String
    let category: WgerCategory?
    let equipment: [WgerEquipment]
    let images: [WgerImage]
}

private struct WgerCategory: Decodable { let name: String }
private struct WgerEquipment: Decodable { let name: String }
private struct WgerImage: Decodable { let image: URL }
