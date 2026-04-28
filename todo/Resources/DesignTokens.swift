import SwiftUI

extension Color {
    static let priorityHigh   = Color("PriorityHigh")
    static let priorityMedium = Color("PriorityMedium")
    static let priorityLow    = Color("PriorityLow")
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
