import SwiftUI

struct SwiftUITaskListView: View {
    @State private var tasks: [TaskModel] = []
    @State private var showingAddTask = false
    @State private var showingLogoutAlert = false
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    private let apiManager = APIManager.shared
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("📝 Задачи")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("SwiftUI + URLSession + UserDefaults")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Action buttons
                    HStack(spacing: 8) {
                        Button(action: loadTasksFromAPI) {
                            HStack {
                                Image(systemName: "cloud.download")
                                    .font(.caption)
                                Text("Из API")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                        .disabled(isLoading)
                        
                        Button(action: { showingAddTask = true }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.caption)
                                Text("Добавить")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .disabled(isLoading)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Error message
                if let errorMessage = errorMessage {
                    HStack {
                        Text("⚠️ \(errorMessage)")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button("Закрыть") {
                            self.errorMessage = nil
                        }
                        .font(.subheadline)
                        .foregroundColor(.red)
                    }
                    .padding(12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
                // Tasks list or empty state
                if tasks.isEmpty && !isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Text("📋")
                            .font(.system(size: 48))
                        
                        Text("Нет задач")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("Добавьте новую или загрузите из API")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskRowView(task: tasks[index]) {
                                toggleTask(at: index)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Loading indicator
                if isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Загрузка через URLSession...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Выйти") {
                        showingLogoutAlert = true
                    }
                }
            }
        }
        .onAppear {
            loadTasks()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView { title, description in
                addTask(title: title, description: description)
            }
        }
        .alert("Выход", isPresented: $showingLogoutAlert) {
            Button("Выйти", role: .destructive) {
                logout()
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Вы уверены, что хотите выйти?")
        }
    }
    
    private func loadTasks() {
        tasks = dataManager.loadTasks()
    }
    
    private func loadTasksFromAPI() {
        isLoading = true
        errorMessage = nil
        
        apiManager.fetchTasks { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let apiTasks):
                    tasks = apiTasks
                    dataManager.saveTasks(apiTasks)
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func addTask(title: String, description: String) {
        let newTask = TaskModel(title: title, description: description)
        
        apiManager.createTask(newTask) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let createdTask):
                    tasks.append(createdTask)
                    dataManager.saveTasks(tasks)
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func toggleTask(at index: Int) {
        guard index < tasks.count else { return }
        tasks[index].isCompleted.toggle()
        dataManager.saveTasks(tasks)
    }
    
    private func logout() {
        dataManager.logout()
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Native Task Row View
struct TaskRowView: View {
    let task: TaskModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(task.isCompleted ? .blue : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Task content
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .strikethrough(task.isCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(task.isCompleted ? .secondary.opacity(0.6) : .secondary)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.isCompleted ? Color.gray.opacity(0.1) : Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(task.isCompleted ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    @State private var title = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
    let onSave: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("➕ Новая задача")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                VStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Название")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Изучить SwiftUI...", text: $title)
                            .textFieldStyle(NativeTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Описание")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Подробности задачи...", text: $description, axis: .vertical)
                            .textFieldStyle(NativeTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                
                HStack(spacing: 12) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    
                    Button("Создать") {
                        saveTask()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(title.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(title.isEmpty)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func saveTask() {
        if !title.isEmpty {
            onSave(title, description)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview
struct NativeSwiftUITaskListView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUITaskListView()
    }
} 
