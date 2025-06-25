# 🚀 Kotlin Multiplatform Mobile Project

Этот проект демонстрирует использование **Kotlin Multiplatform Mobile (KMM)** для разработки общей бизнес-логики, которая используется в iOS приложении.

## 📁 Структура проекта

```
TechComparisonKMP/
├── composeApp/                     # Основной модуль
│   ├── src/
│   │   ├── commonMain/kotlin/      # Общий код для всех платформ
│   │   │   ├── com/techcomparison/kmp/
│   │   │   │   ├── models/         # Модели данных
│   │   │   │   │   ├── Task.kt     # Модель задачи
│   │   │   │   │   └── User.kt     # Модель пользователя
│   │   │   │   ├── api/            # Сетевой слой
│   │   │   │   │   └── ApiClient.kt # HTTP клиент на Ktor
│   │   │   │   └── KMPManager.kt   # Фасад для iOS интеграции
│   │   │   ├── App.kt              # Compose UI
│   │   │   └── Platform.kt         # Expect/actual объявления
│   │   ├── iosMain/kotlin/         # iOS специфичный код
│   │   │   └── com/techcomparison/kmp/
│   │   │       └── models/
│   │   │           └── Platform.kt # iOS реализации
│   │   └── androidMain/kotlin/     # Android специфичный код
│   └── build.gradle.kts            # Конфигурация сборки
├── iosApp/                         # iOS приложение (Compose)
├── gradle/                         # Gradle конфигурация
└── README.md                       # Этот файл
```

## 🛠 Технологии

### Общие зависимости (commonMain)
- **Kotlinx Coroutines** - асинхронное программирование
- **Kotlinx Serialization** - сериализация JSON
- **Ktor Client** - HTTP клиент
- **Compose Multiplatform** - UI фреймворк

### Платформо-специфичные
- **iOS**: Ktor Darwin engine
- **Android**: Ktor Android engine

## 🔧 Сборка

### iOS фреймворк
```bash
# Сборка для симулятора ARM64
./gradlew composeApp:linkDebugFrameworkIosSimulatorArm64

# Сборка для устройства
./gradlew composeApp:linkDebugFrameworkIosArm64

# Универсальный фреймворк
./gradlew composeApp:createXCFramework
```

### Android APK
```bash
./gradlew composeApp:assembleDebug
```

## 📱 Интеграция с iOS

1. **Соберите фреймворк**:
   ```bash
   ./gradlew composeApp:linkDebugFrameworkIosSimulatorArm64
   ```

2. **Найдите фреймворк**:
   ```
   composeApp/build/bin/iosSimulatorArm64/debugFramework/ComposeApp.framework
   ```

3. **Добавьте в iOS проект** и импортируйте:
   ```swift
   import ComposeApp
   
   let kmp = ComposeApp.KMPManager.shared
   ```

## 🎯 Основные компоненты

### KMPManager - Фасад для iOS
```kotlin
class KMPManager {
    companion object { val shared = KMPManager() }
    
    fun login(username: String, password: String, 
             onSuccess: (User) -> Unit, onError: (String) -> Unit)
    
    fun loadTasks(onSuccess: (List<Task>) -> Unit, onError: (String) -> Unit)
    
    fun addTask(title: String, description: String,
               onSuccess: (Task) -> Unit, onError: (String) -> Unit)
}
```

### Модели данных
```kotlin
@Serializable
data class Task(
    val id: String = generateUUID(),
    val title: String,
    val description: String,
    val isCompleted: Boolean = false,
    val createdAt: Long = getCurrentTimestamp()
)

@Serializable  
data class User(
    val id: String = generateUUID(),
    val username: String,
    val email: String,
    val isLoggedIn: Boolean = false
)
```

### API клиент
```kotlin
class ApiClient {
    suspend fun login(username: String, password: String): Result<User>
    suspend fun fetchTasks(): Result<List<Task>>
    suspend fun createTask(task: Task): Result<Task>
}
```

## 🧪 Тестирование

### Тестовые данные
- **Логин**: `admin`
- **Пароль**: `password`
- **API**: JSONPlaceholder (для демонстрации)

### Функции для тестирования
1. Авторизация пользователя
2. Загрузка задач (локальные + API)
3. Создание новых задач
4. Переключение статуса выполнения
5. Валидация данных

## 📊 Метрики проекта

| Метрика | Значение |
|---------|----------|
| **Общий код** | ~400 строк |
| **iOS код** | ~50 строк |
| **Переиспользование** | 88% |
| **Время сборки** | ~2 мин |
| **Размер фреймворка** | ~15 МБ |

## 🔍 Отладка

### Логи
KMM выводит подробные логи HTTP запросов и операций:
```
[KMM] Loading tasks...
[KMM] API request: GET https://jsonplaceholder.typicode.com/todos
[KMM] Response: 200 OK
[KMM] Tasks loaded: 10
```

### Проблемы и решения

1. **Фреймворк не найден**:
   - Проверьте Framework Search Paths
   - Убедитесь что фреймворк добавлен как "Embed & Sign"

2. **Ошибки компиляции**:
   - Очистите build кэш: `./gradlew clean`
   - Пересоберите: `./gradlew build`

3. **Сетевые ошибки**:
   - Проверьте интернет соединение
   - Посмотрите логи Ktor в консоли

## 🌟 Преимущества KMM

### ✅ Плюсы
- **Переиспользование логики** между платформами
- **Типобезопасность** Kotlin
- **Нативная производительность** UI
- **Постепенная миграция** существующих проектов
- **Единый источник истины** для бизнес-логики

### ⚠️ Особенности
- Требует знания Kotlin
- Дополнительная настройка сборки
- Больший размер приложения
- Более сложная архитектура

## 🔗 Полезные ссылки

- [Kotlin Multiplatform Mobile](https://kotlinlang.org/docs/multiplatform-mobile-getting-started.html)
- [Ktor Documentation](https://ktor.io/docs/getting-started-ktor-client.html)
- [Kotlinx Serialization](https://kotlinlang.org/docs/serialization.html)
- [Compose Multiplatform](https://www.jetbrains.com/lp/compose-multiplatform/)

## 📝 Лицензия

MIT License - используйте для обучения и экспериментов. 