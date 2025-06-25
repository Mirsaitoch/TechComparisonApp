package com.techcomparison.kmp

import com.techcomparison.kmp.api.ApiClient
import com.techcomparison.kmp.models.TaskModel
import com.techcomparison.kmp.models.User
import kotlinx.coroutines.*

/**
 * Main facade for iOS integration with KMM
 * Provides simple callback-based API for iOS
 */
class KMPManager {
    companion object {
        val shared = KMPManager()
    }
    
    private val apiClient = ApiClient.instance
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    
    private var tasks: MutableList<TaskModel> = TaskModel.createSampleTasks().toMutableList()
    private var currentUser: User? = null
    
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
                    currentUser = user
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
        currentUser = null
    }
    
    fun getCurrentUser(): User? = currentUser
    
    // MARK: - Tasks Management
    
    fun loadTasks(
        onSuccess: (List<TaskModel>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                // Return current tasks immediately
                onSuccess(tasks.toList())
            } catch (e: Exception) {
                onError(e.message ?: "Unknown error")
            }
        }
    }
    
    fun fetchTasksFromAPI(
        onSuccess: (List<TaskModel>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val result = apiClient.fetchTasks()
                if (result.isSuccess) {
                    val fetchedTasks = result.getOrNull() ?: emptyList()
                    tasks.clear()
                    tasks.addAll(fetchedTasks)
                    onSuccess(tasks.toList())
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
        onSuccess: (TaskModel) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            try {
                val task = TaskModel(title = title, description = description)
                val result = apiClient.createTask(task)
                if (result.isSuccess) {
                    val newTask = result.getOrNull() ?: task
                    tasks.add(0, newTask) // Add to beginning
                    onSuccess(newTask)
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
            val index = tasks.indexOfFirst { it.id == taskId }
            if (index != -1) {
                val task = tasks[index]
                tasks[index] = task.copy(isCompleted = !task.isCompleted)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }
    
    fun deleteTask(taskId: String): Boolean {
        return try {
            tasks.removeAll { it.id == taskId }
        } catch (e: Exception) {
            false
        }
    }
    
    // MARK: - Utility methods for iOS
    
    fun getCurrentTasks(): List<TaskModel> = tasks.toList()
    
    fun isValidUsername(username: String): Boolean = User.isValidUsername(username)
    
    fun isValidEmail(email: String): Boolean = User.isValidEmail(email)
    
    fun getKMMInfo(): String {
        return """
            Kotlin Multiplatform Mobile Demo
            ================================
            - Общая бизнес-логика на Kotlin
            - Нативный UI для iOS
            - Использует Ktor для HTTP запросов
            - Kotlinx.serialization для JSON
            - Coroutines для асинхронности
            
            Структура проекта:
            • commonMain - общий код
            • iosMain - iOS реализации
            • androidMain - Android реализации
            
            Преимущества KMM:
            ✅ Разделение логики между платформами  
            ✅ Нативная производительность
            ✅ Типобезопасность Kotlin
            ✅ Постепенная интеграция
            
            Статистика:
            • ~400 строк общего кода
            • ~50 строк iOS-специфичного кода
            • 88% переиспользования кода
        """.trimIndent()
    }
} 