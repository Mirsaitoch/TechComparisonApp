import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaultsKey = "SavedTasks"
    private let currentUserKey = "CurrentUser"
    
    private init() {}
    
    // MARK: - Tasks Management
    func saveTasks(_ tasks: [TaskModel]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadTasks() -> [TaskModel] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let tasks = try? JSONDecoder().decode([TaskModel].self, from: data) else {
            return createSampleTasks()
        }
        return tasks
    }
    
    private func createSampleTasks() -> [TaskModel] {
        return [
            TaskModel(title: "Изучить Swift", description: "Основы языка Swift для iOS разработки"),
            TaskModel(title: "Создать UI", description: "Разработать пользовательский интерфейс"),
            TaskModel(title: "Добавить сеть", description: "Интегрировать работу с API"),
            TaskModel(title: "Тестирование", description: "Написать unit тесты для приложения")
        ]
    }
    
    // MARK: - User Management
    func saveCurrentUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: currentUserKey)
        }
    }
    
    func loadCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
} 
