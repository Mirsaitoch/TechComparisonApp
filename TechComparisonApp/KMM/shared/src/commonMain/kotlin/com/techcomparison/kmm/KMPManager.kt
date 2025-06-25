package com.techcomparison.kmm

import com.techcomparison.kmm.api.ApiClient
import com.techcomparison.kmm.models.Task
import com.techcomparison.kmm.models.User
import com.techcomparison.kmm.repository.TaskRepository
import com.techcomparison.kmm.storage.LocalStorage
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.StateFlow

/**
 * Главный фасад для Kotlin Multiplatform Mobile модуля
 * Предоставляет простой API для интеграции с iOS приложением
 */
class KMPManager {
    companion object {
        val shared = KMPManager()
    }
    
    private val apiClient = ApiClient.instance
    private val taskRepository = TaskRepository.instance
    private val localStorage = LocalStorage.instance
    
    // Корутин скоуп для iOS
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    
    // MARK: - Authentication
    
    fun login(
        username: String,
        password: String,
        onSuccess: (User) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val result = apiClient.login(username, password)
                if (result.isSuccess) {
                    val user = result.getOrNull()!!
                    localStorage.saveUser(user)
                    onSuccess(user)
                } else {
                    onError(result.exceptionOrNull()?.message ?: "Login failed")
                }
            } catch (e: Exception) {
                onError(e.message ?: "Unknown error")
            }
        }
    }
    
    fun logout() {
        localStorage.clearUser()
    }
    
    fun getCurrentUser(): User? {
        return localStorage.getUser()
    }
    
    // MARK: - Tasks Management
    
    fun loadTasks(
        onSuccess: (List<Task>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val result = taskRepository.loadTasks()
                if (result.isSuccess) {
                    onSuccess(result.getOrNull() ?: emptyList())
                } else {
                    onError(result.exceptionOrNull()?.message ?: "Failed to load tasks")
                }
            } catch (e: Exception) {
                onError(e.message ?: "Unknown error")
            }
        }
    }
    
    fun fetchTasksFromAPI(
        onSuccess: (List<Task>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val result = taskRepository.fetchTasksFromApi()
                if (result.isSuccess) {
                    onSuccess(result.getOrNull() ?: emptyList())
                } else {
                    onError(result.exceptionOrNull()?.message ?: "Failed to fetch tasks")
                }
            } catch (e: Exception) {
                onError(e.message ?: "Unknown error")
            }
        }
    }
    
    fun addTask(
        title: String,
        description: String,
        onSuccess: (Task) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val task = Task(title = title, description = description)
                val result = taskRepository.addTask(task)
                if (result.isSuccess) {
                    onSuccess(result.getOrNull() ?: task)
                } else {
                    onError(result.exceptionOrNull()?.message ?: "Failed to add task")
                }
            } catch (e: Exception) {
                onError(e.message ?: "Unknown error")
            }
        }
    }
    
    fun toggleTaskCompletion(taskId: String): Boolean {
        return try {
            val result = taskRepository.toggleTaskCompletion(taskId)
            result.isSuccess
        } catch (e: Exception) {
            false
        }
    }
    
    fun deleteTask(taskId: String): Boolean {
        return try {
            val result = taskRepository.deleteTask(taskId)
            result.isSuccess
        } catch (e: Exception) {
            false
        }
    }
    
    // MARK: - Reactive Tasks Flow for iOS
    
    fun observeTasks(): StateFlow<List<Task>> {
        return taskRepository.tasks
    }
    
    // Utility method for iOS to get current tasks synchronously
    fun getCurrentTasks(): List<Task> {
        return taskRepository.tasks.value
    }
    
    // MARK: - Validation Helpers
    
    fun isValidUsername(username: String): Boolean {
        return User.isValidUsername(username)
    }
    
    fun isValidEmail(email: String): Boolean {
        return User.isValidEmail(email)
    }
    
    // MARK: - Debug
    
    fun getKMMInfo(): String {
        return """
            Kotlin Multiplatform Mobile Demo
            ================================
            - Общая бизнес-логика на Kotlin
            - Нативный UI для iOS
            - Использует Ktor для HTTP запросов
            - Kotlinx.serialization для JSON
            - Coroutines для асинхронности
            
            Преимущества KMM:
            ✅ Разделение логики между платформами
            ✅ Нативная производительность
            ✅ Типобезопасность Kotlin
            ✅ Постепенная интеграция
        """.trimIndent()
    }
} 