import UIKit
import SwiftUI
import ComposeApp

// MARK: - Compose Multiplatform Integration  
// Using Compose UI from Kotlin Multiplatform Mobile

class KMMDemoViewController: UIViewController {
    
    private var composeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeUI()
    }
    
    private func createComposeViewController() -> UIViewController? {
        // Создаем Compose ViewController для демонстрации Compose Multiplatform  
        let vc = MainViewControllerKt.ComposeViewController()
        print("✅ Compose Multiplatform UI загружен через ComposeViewController()!")
        return vc
    }
    
    private func setupComposeUI() {
        view.backgroundColor = .systemBackground
        title = "Compose Multiplatform"
        
        // Создаем Compose KMM UI controller
        // Пробуем разные варианты вызова
        if let viewController = createComposeViewController() {
            composeViewController = viewController
        } else {
            showErrorView()
            return
        }
        
        guard let composeVC = composeViewController else {
            showErrorView()
            return
        }
        
        // Добавляем как child view controller
        addChild(composeVC)
        view.addSubview(composeVC.view)
        composeVC.didMove(toParent: self)
        
        // Настраиваем constraints
        composeVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            composeVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            composeVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composeVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composeVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        print("✅ Compose Multiplatform UI загружен успешно!")
    }
    
    private func showErrorView() {
        let errorLabel = UILabel()
        errorLabel.text = "❌ Ошибка загрузки Compose UI"
        errorLabel.textAlignment = .center
        errorLabel.font = .systemFont(ofSize: 18, weight: .medium)
        errorLabel.textColor = .systemRed
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Очистка resources при необходимости
        if let composeVC = composeViewController {
            composeVC.willMove(toParent: nil)
            composeVC.view.removeFromSuperview()
            composeVC.removeFromParent()
        }
    }
} 
