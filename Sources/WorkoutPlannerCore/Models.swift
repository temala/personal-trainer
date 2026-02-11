import Foundation

public struct UserGoalProfile: Codable, Equatable {
    public var focusMuscles: [String]
    public var reducedMuscles: [String]
    public var excludedMuscles: [String]
    public var cardioEnabled: Bool
    public var restingHeartRateTarget: Int?

    public init(
        focusMuscles: [String],
        reducedMuscles: [String],
        excludedMuscles: [String],
        cardioEnabled: Bool,
        restingHeartRateTarget: Int?
    ) {
        self.focusMuscles = focusMuscles
        self.reducedMuscles = reducedMuscles
        self.excludedMuscles = excludedMuscles
        self.cardioEnabled = cardioEnabled
        self.restingHeartRateTarget = restingHeartRateTarget
    }
}

public struct Exercise: Codable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let primaryMuscle: String
    public let equipment: String
    public let imageURL: URL?

    public init(id: Int, name: String, primaryMuscle: String, equipment: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.equipment = equipment
        self.imageURL = imageURL
    }
}

public struct PlanExercise: Codable, Equatable, Identifiable {
    public let id: Int
    public let exercise: Exercise
    public let sets: Int
    public let repRange: ClosedRange<Int>
    public let alternatives: [Exercise]

    public init(id: Int, exercise: Exercise, sets: Int, repRange: ClosedRange<Int>, alternatives: [Exercise]) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.repRange = repRange
        self.alternatives = alternatives
    }
}

public struct WorkoutPlan: Codable, Equatable {
    public var createdAt: Date
    public var queue: [PlanExercise]

    public init(createdAt: Date, queue: [PlanExercise]) {
        self.createdAt = createdAt
        self.queue = queue
    }
}

public struct PerformanceRecord: Codable, Equatable {
    public var exerciseID: Int
    public var maxKg: Double

    public init(exerciseID: Int, maxKg: Double) {
        self.exerciseID = exerciseID
        self.maxKg = maxKg
    }
}
