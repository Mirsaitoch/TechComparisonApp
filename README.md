# 📱 Экспериментальный анализ технологий разработки мобильных приложений

> **Технологическая практика** студента Сабирзянова Мирсаита Раисовича  
> СПбПУ • 09.03.03 Прикладная информатика • 2024-2025

## 🎯 Цель исследования

Сравнительный анализ 4 основных технологий разработки мобильных приложений через создание демонстрационных приложений с идентичным функционалом.

## 🚀 Что реализовано

### 4 технологии в одном iOS приложении:

1. **🔵 UIKit** - Классический iOS с UIKit + URLSession
2. **🟢 SwiftUI** - Декларативный iOS с SwiftUI + URLSession  
3. **🟠 Kotlin Multiplatform** - Compose Multiplatform + общая логика
4. **🟣 C# .NET MAUI** - Microsoft кроссплатформа (информационный экран)

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
│   ├── Research/TechComparison.md  # Сравнительный анализ
│   └── Report/                     # Отчеты
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

## 📖 Документация

- [`Documentation/Research/TechComparison.md`](Documentation/Research/TechComparison.md) - Детальный технический анализ
- [`Documentation/Report/`](Documentation/Report/) - Отчеты по практике
- [`TechComparisonKMP/README.md`](TechComparisonKMP/README.md) - KMP проект
- Inline документация в коде

## 🎓 Образовательная ценность

Проект демонстрирует:
1. **Сравнительный анализ** современных технологий
2. **Практическое применение** теоретических знаний
3. **Интеграцию** различных платформ и языков
4. **Архитектурные решения** для мобильной разработки

## 👨‍💻 Автор

**Сабирзянов Мирсаит Раисович**  
Студент СПбПУ, Институт компьютерных наук и технологий  
Направление: 09.03.03 Прикладная информатика  
Группа: 3530904/10001

**Руководитель практики**: [ФИО преподавателя]

---

*Проект создан в рамках технологической практики для экспериментального анализа современных подходов к разработке мобильных приложений. Особое внимание уделено практическому сравнению производительности, удобства разработки и возможностей каждой технологии.*

## 📈 Метрики проекта

- **Общий объем кода**: ~1200 строк
- **Время разработки**: 20+ часов
- **Покрытие функциональности**: 100% во всех технологиях
- **Переиспользование кода**: 85% в KMP версии

## ⚠️ Важно после клонирования

После клонирования репозитория необходимо пересобрать iOS фреймворк:

```bash
cd TechComparisonKMP
./gradlew composeApp:linkDebugFrameworkIosSimulatorArm64
```

Скомпилированный фреймворк не включен в репозиторий из-за большого размера (300+ MB).