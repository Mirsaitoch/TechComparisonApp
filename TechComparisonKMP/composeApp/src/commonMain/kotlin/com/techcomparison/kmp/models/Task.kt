package com.techcomparison.kmp.models

import kotlinx.serialization.Serializable

@Serializable
data class TaskModel(
    val id: String = generateUUID(),
    val title: String,
    val description: String,
    val isCompleted: Boolean = false,
    val createdAt: Long = getCurrentTimestamp()
) {
    companion object {
        fun createSampleTasks(): List<TaskModel> = listOf(
            TaskModel(
                title = "Изучить Kotlin Multiplatform",
                description = "Освоить основы KMP для мобильной разработки"
            ),
            TaskModel(
                title = "Создать общую бизнес-логику",
                description = "Разработать API клиент и модели данных"
            ),
            TaskModel(
                title = "Интегрировать с iOS",
                description = "Подключить Kotlin модуль к iOS приложению"
            ),
            TaskModel(
                title = "Протестировать кроссплатформенность",
                description = "Убедиться что код работает на обеих платформах"
            )
        )
    }
}

// Platform-specific implementations
expect fun generateUUID(): String
expect fun getCurrentTimestamp(): Long 