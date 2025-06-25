package com.techcomparison.kmm.storage

import com.techcomparison.kmm.models.Task
import com.techcomparison.kmm.models.User

expect class LocalStorage() {
    fun saveTasks(tasks: List<Task>)
    fun getTasks(): List<Task>
    
    fun saveUser(user: User)
    fun getUser(): User?
    fun clearUser()
    
    companion object {
        val instance: LocalStorage
    }
} 