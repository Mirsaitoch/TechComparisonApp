import Foundation

struct User: Codable {
    let id: UUID
    var username: String
    var email: String
    var isLoggedIn: Bool = false
    
    init(username: String, email: String) {
        self.id = UUID()
        self.username = username
        self.email = email
    }
}

// Простая валидация
extension User {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        return username.count >= 3 && username.count <= 20
    }
} 