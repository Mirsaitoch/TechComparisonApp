package com.techcomparison.kmm.storage

import com.techcomparison.kmm.models.Task
import com.techcomparison.kmm.models.User
import kotlinx.serialization.encodeToString
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import platform.Foundation.NSUserDefaults

actual class LocalStorage {
    private val userDefaults = NSUserDefaults.standardUserDefaults
    
    private val tasksKey = "saved_tasks_kmm"
    private val userKey = "current_user_kmm"
    
    actual fun saveTasks(tasks: List<Task>) {
        try {
            val json = Json.encodeToString(tasks)
            userDefaults.setObject(json, tasksKey)
            userDefaults.synchronize()
        } catch (e: Exception) {
            println("Error saving tasks: ${e.message}")
        }
    }
    
    actual fun getTasks(): List<Task> {
        return try {
            val json = userDefaults.stringForKey(tasksKey)
            if (json != null) {
                Json.decodeFromString<List<Task>>(json)
            } else {
                Task.createSampleTasks()
            }
        } catch (e: Exception) {
            println("Error loading tasks: ${e.message}")
            Task.createSampleTasks()
        }
    }
    
    actual fun saveUser(user: User) {
        try {
            val json = Json.encodeToString(user)
            userDefaults.setObject(json, userKey)
            userDefaults.synchronize()
        } catch (e: Exception) {
            println("Error saving user: ${e.message}")
        }
    }
    
    actual fun getUser(): User? {
        return try {
            val json = userDefaults.stringForKey(userKey)
            if (json != null) {
                Json.decodeFromString<User>(json)
            } else {
                null
            }
        } catch (e: Exception) {
            println("Error loading user: ${e.message}")
            null
        }
    }
    
    actual fun clearUser() {
        userDefaults.removeObjectForKey(userKey)
        userDefaults.synchronize()
    }
    
    actual companion object {
        actual val instance: LocalStorage = LocalStorage()
    }
} 