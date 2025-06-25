package com.techcomparison.kmm.repository

import com.techcomparison.kmm.api.ApiClient
import com.techcomparison.kmm.models.Task
import com.techcomparison.kmm.storage.LocalStorage
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class TaskRepository {
    companion object {
        val instance = TaskRepository()
    }
    
    private val apiClient = ApiClient.instance
    private val localStorage = LocalStorage.instance
    
    private val _tasks = MutableStateFlow<List<Task>>(emptyList())
    val tasks: StateFlow<List<Task>> = _tasks.asStateFlow()
    
    init {
        _tasks.value = localStorage.getTasks()
    }
    
    suspend fun loadTasks(): Result<List<Task>> {
        return try {
            val savedTasks = localStorage.getTasks()
            _tasks.value = savedTasks
            Result.success(savedTasks)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun fetchTasksFromApi(): Result<List<Task>> {
        return try {
            val result = apiClient.fetchTasks()
            if (result.isSuccess) {
                val tasks = result.getOrNull() ?: emptyList()
                _tasks.value = tasks
                localStorage.saveTasks(tasks)
            }
            result
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun addTask(task: Task): Result<Task> {
        return try {
            val result = apiClient.createTask(task)
            if (result.isSuccess) {
                val newTask = result.getOrNull() ?: task
                val updatedTasks = listOf(newTask) + _tasks.value
                _tasks.value = updatedTasks
                localStorage.saveTasks(updatedTasks)
            }
            result
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    fun updateTask(updatedTask: Task): Result<Task> {
        return try {
            val currentTasks = _tasks.value.toMutableList()
            val index = currentTasks.indexOfFirst { it.id == updatedTask.id }
            
            if (index != -1) {
                currentTasks[index] = updatedTask
                _tasks.value = currentTasks
                localStorage.saveTasks(currentTasks)
                Result.success(updatedTask)
            } else {
                Result.failure(Exception("Task not found"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    fun deleteTask(taskId: String): Result<Unit> {
        return try {
            val updatedTasks = _tasks.value.filter { it.id != taskId }
            _tasks.value = updatedTasks
            localStorage.saveTasks(updatedTasks)
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    fun toggleTaskCompletion(taskId: String): Result<Task> {
        return try {
            val currentTasks = _tasks.value.toMutableList()
            val index = currentTasks.indexOfFirst { it.id == taskId }
            
            if (index != -1) {
                val task = currentTasks[index]
                val updatedTask = task.copy(isCompleted = !task.isCompleted)
                currentTasks[index] = updatedTask
                _tasks.value = currentTasks
                localStorage.saveTasks(currentTasks)
                Result.success(updatedTask)
            } else {
                Result.failure(Exception("Task not found"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
} 