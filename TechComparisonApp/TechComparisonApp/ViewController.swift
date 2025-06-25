//
//  MainViewController.swift
//  TechComparisonApp
//
//  Created by Мирсаит Сабирзянов on 22.06.2025.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let uikitButton = UIButton(type: .system)
    private let swiftuiButton = UIButton(type: .system)
    private let kmpButton = UIButton(type: .system)
    private let csharpButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Сравнение Технологий"
        
        // Title
        titleLabel.text = "iOS Технологии"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // Subtitle
        subtitleLabel.text = "Экспериментальный анализ различных подходов к разработке"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        setupButton(uikitButton, title: "UIKit", 
                   subtitle: "Классический iOS с UIKit + URLSession", 
                   color: .systemBlue, 
                   action: #selector(uikitTapped))
        
        setupButton(swiftuiButton, title: "SwiftUI", 
                   subtitle: "Декларативный SwiftUI + Combine", 
                   color: .systemGreen, 
                   action: #selector(swiftuiTapped))
        
        setupButton(kmpButton, title: "Kotlin Multiplatform", 
                   subtitle: "Compose Multiplatform + общая логика", 
                   color: .systemOrange, 
                   action: #selector(kmpTapped))
        
        setupButton(csharpButton, title: "C# .NET MAUI", 
                   subtitle: "Microsoft кроссплатформа", 
                   color: .systemPurple, 
                   action: #selector(csharpTapped))
        
        // Setup scroll view
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to content view
        [titleLabel, subtitleLabel, uikitButton, swiftuiButton, kmpButton, csharpButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupButton(_ button: UIButton, title: String, subtitle: String, color: UIColor, action: Selector) {
        button.backgroundColor = color
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Create attributed title with subtitle
        let attributedTitle = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
        )
        
        attributedTitle.append(NSAttributedString(
            string: "\n\(subtitle)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.8)
            ]
        ))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        // Add shadow
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
    }
    
    private func setupConstraints() {
        [scrollView, contentView, titleLabel, subtitleLabel, uikitButton, swiftuiButton, kmpButton, csharpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // UIKit button
            uikitButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            uikitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uikitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uikitButton.heightAnchor.constraint(equalToConstant: 80),
            
            // SwiftUI button
            swiftuiButton.topAnchor.constraint(equalTo: uikitButton.bottomAnchor, constant: 20),
            swiftuiButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            swiftuiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            swiftuiButton.heightAnchor.constraint(equalToConstant: 80),
            
            // KMP button
            kmpButton.topAnchor.constraint(equalTo: swiftuiButton.bottomAnchor, constant: 20),
            kmpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            kmpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            kmpButton.heightAnchor.constraint(equalToConstant: 80),
            
            // C# button
            csharpButton.topAnchor.constraint(equalTo: kmpButton.bottomAnchor, constant: 20),
            csharpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            csharpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            csharpButton.heightAnchor.constraint(equalToConstant: 80),
            csharpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func uikitTapped() {
        let loginVC = UIKitLoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func swiftuiTapped() {
        let swiftUIView = SwiftUILoginView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc private func kmpTapped() {
        let kmmVC = KMMDemoViewController()
        navigationController?.pushViewController(kmmVC, animated: true)
    }
    
    @objc private func csharpTapped() {
        showInfoAlert(title: "C# .NET MAUI", 
                     message: ".NET MAUI позволяет создавать кроссплатформенные приложения с единым UI и логикой на C#.\n\nОсновные преимущества:\n• Один код для всех платформ\n• Мощные инструменты разработки\n• Интеграция с экосистемой Microsoft")
    }
    
    private func showInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

