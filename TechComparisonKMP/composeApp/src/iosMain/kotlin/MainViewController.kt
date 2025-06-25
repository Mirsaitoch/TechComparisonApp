import androidx.compose.ui.window.ComposeUIViewController
import com.techcomparison.kmp.App
import platform.UIKit.UIViewController

// Создаем Compose ViewController для демонстрации Compose Multiplatform
fun ComposeViewController(): UIViewController = ComposeUIViewController { App() } 