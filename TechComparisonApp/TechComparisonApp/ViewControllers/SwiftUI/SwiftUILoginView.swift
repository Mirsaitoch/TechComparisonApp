import SwiftUI

struct SwiftUILoginView: View {
    @State private var username = "admin"
    @State private var password = "password"
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showingTaskList = false
    
    private let apiManager = APIManager.shared
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🔐 Вход в систему")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Нативная iOS авторизация")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Login Form
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Логин")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("Логин", text: $username)
                                .textFieldStyle(NativeTextFieldStyle())
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Пароль")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Пароль", text: $password)
                                .textFieldStyle(NativeTextFieldStyle())
                        }
                        
                        Button(action: login) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                } else {
                                    Text("Войти")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                            .foregroundColor(.white)
                        }
                        .disabled(isLoading || username.isEmpty || password.isEmpty)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    // Error message
                    if let errorMessage = errorMessage {
                        HStack {
                            Text("⚠️ \(errorMessage)")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Button("✕") {
                                self.errorMessage = nil
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.1))
                        )
                        .padding(.horizontal, 24)
                    }
                    
                    // Info Card
                    VStack(spacing: 16) {
                        Text("📱")
                            .font(.system(size: 48))
                        
                        Text("SwiftUI")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Декларативный iOS UI с SwiftUI, URLSession и UserDefaults. Нативный подход без внешних зависимостей.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.large)
        }
        .fullScreenCover(isPresented: $showingTaskList) {
            SwiftUITaskListView()
        }
    }
    
    private func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        apiManager.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let user):
                    dataManager.saveCurrentUser(user)
                    showingTaskList = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// Стили текстовых полей импортируются из CommonTextFieldStyles.swift

// MARK: - Preview
struct SwiftUILoginView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILoginView()
    }
} 