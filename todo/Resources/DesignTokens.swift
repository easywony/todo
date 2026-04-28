import SwiftUI

extension Color {
    static let priorityHigh   = Color(red: 1.0,   green: 0.231, blue: 0.188) // #ff3b30
    static let priorityMedium = Color(red: 1.0,   green: 0.584, blue: 0.0)   // #ff9500
    static let priorityLow    = Color(red: 0.204, green: 0.780, blue: 0.349) // #34c759
}

extension Todo.Priority {
    var color: Color {
        switch self {
        case .high:   return .priorityHigh
        case .medium: return .priorityMedium
        case .low:    return .priorityLow
        }
    }

    var label: String {
        switch self {
        case .high:   return "높음"
        case .medium: return "중간"
        case .low:    return "낮음"
        }
    }
}
