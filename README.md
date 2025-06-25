# 📱 Экспериментальный анализ технологий разработки мобильных приложений

> **Технологическая практика** студента Сабирзянова Мирсаита Раисовича  
> СПбПУ • 09.03.03 Прикладная информатика • 2024-2025

## 🎯 Цель исследования

Сравнительный анализ 4 основных технологий разработки мобильных приложений через создание демонстрационных приложений с идентичным функционалом.

## 🚀 Что реализовано

### 4 технологии в одном iOS приложении:
<img width="250" alt="image" src="https://github.com/user-attachments/assets/3edd795d-8ef1-47e7-9763-414fc8a7487b" />

1. **🔵 UIKit** - Классический iOS с UIKit + URLSession
   
   <img width="250" alt="image" src="https://github.com/user-attachments/assets/f91e664f-584d-4e12-b184-c782a77c3b79" />
3. **🟢 SwiftUI** - Декларативный iOS с SwiftUI + URLSession
   
   <img width="250" alt="image" src="https://github.com/user-attachments/assets/535472b4-bd40-40bb-9dbb-2fb1d77b4fbb" />
5. **🟠 Kotlin Multiplatform** - Compose Multiplatform + общая логика
   
   <img width="250" alt="image" src="https://github.com/user-attachments/assets/c1de6e8d-a3c9-46fe-bbe4-90682ee70b98" />
7. **🟣 C# .NET MAUI** - Microsoft кроссплатформа (информационный экран)
   
### Единый функционал для всех технологий:
- ✅ Экран авторизации (admin/password)
- ✅ Список задач с CRUD операциями
- ✅ API интеграция (JSONPlaceholder)
- ✅ Локальное хранение данных
- ✅ Управление состояниями

### 🔥 Особенности KMP интеграции:
- Полноценный Kotlin Multiplatform проект
- Общие модели и бизнес-логика на Kotlin
- HTTP клиент на Ktor
- Compose Multiplatform UI
- Реальная интеграция через iOS фреймворк

## 📁 Структура проекта

```
Практика/
├── TechComparisonApp/              # 📱 Главное iOS приложение
│   ├── ViewControllers/
│   │   ├── UIKit/                  # 🔵 UIKit реализация
│   │   │   ├── UIKitLoginViewController.swift
│   │   │   └── UIKitTaskListViewController.swift
│   │   ├── SwiftUI/                # 🟢 SwiftUI реализация  
│   │   │   ├── SwiftUILoginView.swift
│   │   │   ├── SwiftUITaskListView.swift
│   │   │   └── CommonTextFieldStyles.swift
│   │   ├── KMP/                    # 🟠 KMP интеграция
│   │   │   └── KMMDemoViewController.swift
│   │   └── C#/                     # 🟣 C# заглушка
│   ├── Models/                     # Нативные iOS модели
│   ├── Utils/                      # Сервисы (APIManager, DataManager)
│   └── ComposeApp.framework        # 🔥 KMP фреймворк
├── TechComparisonKMP/              # 🟠 Kotlin Multiplatform проект
│   ├── composeApp/
│   │   ├── src/commonMain/         # Общий Kotlin код
│   │   ├── src/iosMain/            # iOS-специфичный код
│   │   └── src/androidMain/        # Android код (будущее)
│   └── gradle.properties
├── Documentation/                  # 📚 Исследование и отчет
│   ├── Отчет_по_практике.md  # Отчет
└── README.md                       # Этот файл
```

## 🎮 Запуск и тестирование

### Быстрый старт:
1. Откройте `TechComparisonApp.xcodeproj` в Xcode
2. Убедитесь, что `ComposeApp.framework` добавлен в проект
3. Запустите на симуляторе iOS
4. Тестируйте все 4 технологии:
   - Логин: `admin` / Пароль: `password`

### Пересборка KMP фреймворка (при необходимости):
```bash
cd TechComparisonKMP
./gradlew composeApp:linkDebugFrameworkIosSimulatorArm64
```

### Kotlin Multiplatform:
- **Kotlin 1.9+** с Coroutines
- **Compose Multiplatform** для UI
- **Ktor** для HTTP клиента
- **Kotlinx.serialization** для JSON
- **Material Design 3** компоненты

### Общие инструменты:
- **Xcode 15+** для iOS разработки
- **Android Studio** для KMP
- **Git** для версионного контроля
- **JSONPlaceholder** как тестовый API

## 🎓 Образовательная ценность

Проект демонстрирует:
1. **Сравнительный анализ** современных технологий
2. **Практическое применение** теоретических знаний
3. **Интеграцию** различных платформ и языков
4. **Архитектурные решения** для мобильной разработки



## ⚠️ Важно после клонирования

После клонирования репозитория необходимо пересобрать iOS фреймворк:

```bash
cd TechComparisonKMP
./gradlew composeApp:linkDebugFrameworkIosSimulatorArm64
```

Скомпилированный фреймворк не включен в репозиторий из-за большого размера (300+ MB).
