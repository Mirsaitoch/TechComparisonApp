import Foundation

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    private init() {}
    
    // MARK: - Login Simulation
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Симуляция сетевого запроса
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if username.lowercased() == "admin" && password == "password" {
                let user = User(username: username, email: "admin@example.com")
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                let error = NSError(domain: "LoginError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Неверный логин или пароль"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Tasks API
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/todos") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            do {
                let jsonTasks = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
                let tasks = jsonTasks.prefix(10).compactMap { dict -> TaskModel? in
                    guard let title = dict["title"] as? String,
                          let completed = dict["completed"] as? Bool else {
                        return nil
                    }
                    var task = TaskModel(title: title, description: "Загружено из API")
                    task.isCompleted = completed
                    return task
                }
                
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Create Task
    func createTask(_ task: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        // Симуляция создания задачи
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async {
                completion(.success(task))
            }
        }
    }
} 
