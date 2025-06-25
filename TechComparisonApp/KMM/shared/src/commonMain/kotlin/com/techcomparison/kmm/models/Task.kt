package com.techcomparison.kmm.models

import kotlinx.serialization.Serializable

@Serializable
data class Task(
    val id: String = generateUUID(),
    val title: String,
    val description: String,
    val isCompleted: Boolean = false,
    val createdAt: Long = getCurrentTimestamp()
) {
    companion object {
        fun createSampleTasks(): List<Task> = listOf(
            Task(
                title = "Изучить Kotlin Multiplatform",
                description = "Освоить основы KMP для мобильной разработки"
            ),
            Task(
                title = "Создать общую бизнес-логику",
                description = "Разработать API клиент и модели данных"
            ),
            Task(
                title = "Интегрировать с iOS",
                description = "Подключить Kotlin модуль к iOS приложению"
            ),
            Task(
                title = "Протестировать кроссплатформенность",
                description = "Убедиться что код работает на обеих платформах"
            )
        )
    }
}

// Платформо-специфичные функции будут реализованы в expect/actual
expect fun generateUUID(): String
expect fun getCurrentTimestamp(): Long 