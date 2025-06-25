# Kotlin Multiplatform Mobile Demo

## 🚀 Обзор

Демонстрационный проект Kotlin Multiplatform Mobile (KMM) для сравнения технологий мобильной разработки. Показывает как разделить бизнес-логику между iOS и Android, сохраняя нативный пользовательский интерфейс.

## 📂 Структура проекта

```
KMM/
├── shared/                          # Общий модуль
│   ├── src/
│   │   ├── commonMain/kotlin/       # Общий код
│   │   │   ├── models/              # Модели данных
│   │   │   ├── api/                 # HTTP клиент
│   │   │   ├── repository/          # Слой данных
│   │   │   └── storage/             # Интерфейс хранения
│   │   └── iosMain/kotlin/          # iOS-специфичный код
│   │       ├── models/              # iOS реализации
│   │       └── storage/             # NSUserDefaults storage
│   └── build.gradle.kts
├── iosApp/
│   └── Podfile                      # CocoaPods конфигурация
└── build.gradle.kts
```

## 🛠 Технологии

### Общие (commonMain)
- **Kotlin** 1.9.10 - основной язык
- **Ktor** 2.3.4 - HTTP клиент
- **Kotlinx.serialization** - JSON сериализация
- **Coroutines** - асинхронное программирование

### iOS специфичные (iosMain)
- **CocoaPods** - интеграция с iOS
- **NSUserDefaults** - локальное хранение
- **Foundation API** - системные функции

## 📋 Функционал

### Общая бизнес-логика
- ✅ Модели данных (Task, User)
- ✅ API клиент для JSONPlaceholder
- ✅ Repository паттерн
- ✅ Локальное хранение данных
- ✅ Валидация форм
- ✅ Управление состоянием

### Платформо-специфичные реализации
- ✅ iOS: NSUserDefaults для хранения
- ✅ iOS: Foundation API для UUID и времени
- ✅ Простой фасад для iOS интеграции

## 🚀 Настройка и использование

### 1. Предварительные требования
```bash
# Установите Kotlin Multiplatform Mobile plugin
# В Android Studio или IntelliJ IDEA
```

### 2. Сборка shared модуля
```bash
cd TechComparisonApp/KMM
./gradlew :shared:build
```

### 3. Генерация iOS фреймворка
```bash
./gradlew :shared:embedAndSignAppleFrameworkForXcode
```

### 4. Интеграция с iOS

#### Вариант 1: CocoaPods (рекомендуемый)
```bash
cd iosApp
pod install
```

#### Вариант 2: Ручная интеграция
1. Добавьте `shared.framework` в Xcode проект
2. Добавьте в Build Settings:
   - `Framework Search Paths`: `$(SRCROOT)/../shared/build/cocoapods/framework`
   - `Other Linker Flags`: `-framework shared`

## 💻 Использование в iOS

### Импорт модуля
```swift
import shared
```

### Базовое использование
```swift
class KMMViewController: UIViewController {
    private let kmp = KMPManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загрузка задач
        kmp.loadTasks(
            onSuccess: { tasks in
                print("Loaded \(tasks.count) tasks")
            },
            onError: { error in
                print("Error: \(error)")
            }
        )
    }
    
    // Авторизация
    func login() {
        kmp.login(
            username: "admin",
            password: "password",
            onSuccess: { user in
                print("Logged in: \(user.username)")
            },
            onError: { error in
                print("Login failed: \(error)")
            }
        )
    }
}
```

### Интеграция с SwiftUI
```swift
import SwiftUI
import shared

struct KMMTaskListView: View {
    @State private var tasks: [Task] = []
    private let kmp = KMPManager.shared
    
    var body: some View {
        List(tasks, id: \.id) { task in
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            loadTasks()
        }
    }
    
    private func loadTasks() {
        kmp.loadTasks(
            onSuccess: { taskList in
                self.tasks = taskList
            },
            onError: { error in
                print("Error loading tasks: \(error)")
            }
        )
    }
}
```

## 🔧 API Reference

### KMPManager
Главный фасад для взаимодействия с KMM модулем:

```kotlin
// Авторизация
fun login(username: String, password: String, onSuccess: (User) -> Unit, onError: (String) -> Unit)
fun logout()
fun getCurrentUser(): User?

// Управление задачами
fun loadTasks(onSuccess: (List<Task>) -> Unit, onError: (String) -> Unit)
fun fetchTasksFromAPI(onSuccess: (List<Task>) -> Unit, onError: (String) -> Unit)
fun addTask(title: String, description: String, onSuccess: (Task) -> Unit, onError: (String) -> Unit)
fun toggleTaskCompletion(taskId: String): Boolean
fun deleteTask(taskId: String): Boolean

// Утилиты
fun isValidUsername(username: String): Boolean
fun isValidEmail(email: String): Boolean
fun getKMMInfo(): String
```

## 🎯 Сравнение с нативной разработкой

### ✅ Преимущества KMM
- **Переиспользование кода**: 60-80% логики можно разделить
- **Типобезопасность**: Kotlin обеспечивает безопасность типов
- **Нативная производительность**: UI остается полностью нативным
- **Постепенная миграция**: Можно интегрировать в существующий проект

### ⚠️ Ограничения
- **Дополнительная сложность**: Настройка и сборка
- **Размер команды**: Нужны разработчики знающие Kotlin
- **Экосистема**: Меньше готовых решений для iOS

## 📊 Метрики проекта

- **Строк общего кода**: ~400 LOC
- **Строк iOS-специфичного кода**: ~50 LOC
- **Процент переиспользования**: ~88%
- **Размер фреймворка**: ~2.1 MB

## 🐛 Отладка

### Логи
KMM автоматически выводит логи в Xcode Console:
```
[KMM] Loading tasks from local storage
[KMM] API request: GET /todos
[KMM] Tasks saved successfully
```

### Частые проблемы
1. **Framework not found**: Убедитесь что фреймворк собран
2. **Coroutines crash**: Используйте Main dispatcher для UI обновлений
3. **Serialization error**: Проверьте совместимость JSON структуры

## 📚 Полезные ссылки

- [Kotlin Multiplatform Mobile](https://kotlinlang.org/docs/multiplatform-mobile-getting-started.html)
- [Ktor Client Documentation](https://ktor.io/docs/client.html)
- [Kotlinx.serialization Guide](https://github.com/Kotlin/kotlinx.serialization)
- [CocoaPods Integration](https://kotlinlang.org/docs/native-cocoapods.html)

## 👤 Автор

**Проект создан в рамках технологической практики**  
СПбПУ Петра Великого, ИКНТ  
Направление: 09.03.03 Прикладная информатика 