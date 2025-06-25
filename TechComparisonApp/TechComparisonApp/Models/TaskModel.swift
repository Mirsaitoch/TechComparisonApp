import Foundation

struct TaskModel: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
} 
