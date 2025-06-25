package com.techcomparison.kmm.api

import com.techcomparison.kmm.models.Task
import com.techcomparison.kmm.models.User
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.coroutines.delay
import kotlinx.serialization.json.Json

class ApiClient {
    companion object {
        val instance = ApiClient()
    }
    
    private val httpClient = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                isLenient = true
            })
        }
        install(Logging) {
            logger = Logger.DEFAULT
            level = LogLevel.INFO
        }
    }
    
    private val baseUrl = "https://jsonplaceholder.typicode.com"
    
    // Симуляция авторизации
    suspend fun login(username: String, password: String): Result<User> {
        return try {
            // Симулируем задержку сети
            delay(1000)
            
            if (username.lowercase() == "admin" && password == "password") {
                Result.success(
                    User(
                        username = username,
                        email = "admin@example.com",
                        isLoggedIn = true
                    )
                )
            } else {
                Result.failure(Exception("Неверный логин или пароль"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    // Загрузка задач с API
    suspend fun fetchTasks(): Result<List<Task>> {
        return try {
            val response: List<TodoItem> = httpClient.get("$baseUrl/todos") {
                parameter("_limit", 10)
            }.body()
            
            val tasks = response.map { todoItem ->
                Task(
                    title = todoItem.title,
                    description = "Загружено из JSONPlaceholder API",
                    isCompleted = todoItem.completed
                )
            }
            
            Result.success(tasks)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    // Создание задачи (симуляция)
    suspend fun createTask(task: Task): Result<Task> {
        return try {
            // Симулируем задержку сети
            delay(500)
            Result.success(task)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    // DTO для JSONPlaceholder API
    @kotlinx.serialization.Serializable
    private data class TodoItem(
        val id: Int,
        val title: String,
        val completed: Boolean,
        val userId: Int
    )
} 