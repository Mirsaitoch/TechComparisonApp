package com.techcomparison.kmm.models

import kotlinx.serialization.Serializable

@Serializable
data class User(
    val id: String = generateUUID(),
    val username: String,
    val email: String,
    val isLoggedIn: Boolean = false
) {
    companion object {
        fun isValidEmail(email: String): Boolean {
            val emailRegex = Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            return emailRegex.matches(email)
        }
        
        fun isValidUsername(username: String): Boolean {
            return username.length in 3..20
        }
    }
} 