import UIKit

class UIKitLoginViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let errorContainerView = UIView()
    private let errorLabel = UILabel()
    private let errorCloseButton = UIButton(type: .system)
    
    private let infoCard = UIView()
    private let infoIcon = UILabel()
    private let infoTitle = UILabel()
    private let infoDescription = UILabel()
    
    private let apiManager = APIManager.shared
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "UIKit"
        navigationItem.largeTitleDisplayMode = .always
        
        // Title
        titleLabel.text = "🔐 Вход в систему"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        // Subtitle
        subtitleLabel.text = "Нативная iOS авторизация"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        
        // Username field
        usernameTextField.placeholder = "Логин"
        usernameTextField.text = "admin"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = .systemBackground
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.font = .systemFont(ofSize: 16)
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        
        // Password field
        passwordTextField.placeholder = "Пароль"
        passwordTextField.text = "password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.layer.borderColor = UIColor.systemGray4.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.font = .systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        
        // Login button
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // Loading indicator
        loadingIndicator.hidesWhenStopped = true
        
        // Error container (hidden by default)
        errorContainerView.backgroundColor = .systemRed.withAlphaComponent(0.1)
        errorContainerView.layer.cornerRadius = 12
        errorContainerView.isHidden = true
        
        errorLabel.font = .systemFont(ofSize: 14, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        
        errorCloseButton.setTitle("✕", for: .normal)
        errorCloseButton.setTitleColor(.systemRed, for: .normal)
        errorCloseButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        errorCloseButton.addTarget(self, action: #selector(hideError), for: .touchUpInside)
        
        // Info card
        infoCard.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        infoCard.layer.cornerRadius = 12
        
        infoIcon.text = "📱"
        infoIcon.font = .systemFont(ofSize: 32)
        infoIcon.textAlignment = .center
        
        infoTitle.text = "UIKit"
        infoTitle.font = .systemFont(ofSize: 18, weight: .bold)
        infoTitle.textColor = .label
        infoTitle.textAlignment = .center
        
        infoDescription.text = "Классический iOS интерфейс с UIKit, URLSession и UserDefaults. Программный подход без внешних зависимостей."
        infoDescription.font = .systemFont(ofSize: 14, weight: .medium)
        infoDescription.textColor = .secondaryLabel
        infoDescription.numberOfLines = 0
        infoDescription.textAlignment = .center
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, subtitleLabel, usernameTextField, passwordTextField, loginButton, loadingIndicator, errorContainerView, infoCard].forEach {
            contentView.addSubview($0)
        }
        
        [errorLabel, errorCloseButton].forEach {
            errorContainerView.addSubview($0)
        }
        
        [infoIcon, infoTitle, infoDescription].forEach {
            infoCard.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [scrollView, contentView, titleLabel, subtitleLabel, usernameTextField, passwordTextField, loginButton, loadingIndicator, errorContainerView, errorLabel, errorCloseButton, infoCard, infoIcon, infoTitle, infoDescription].forEach {
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Username field
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password field
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Login button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Loading indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            // Error container
            errorContainerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            errorContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            errorContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Error label
            errorLabel.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 12),
            errorLabel.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: -12),
            
            // Error close button
            errorCloseButton.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 8),
            errorCloseButton.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -8),
            errorCloseButton.leadingAnchor.constraint(greaterThanOrEqualTo: errorLabel.trailingAnchor, constant: 8),
            errorCloseButton.widthAnchor.constraint(equalToConstant: 30),
            errorCloseButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Info card
            infoCard.topAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: 32),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            infoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Info icon
            infoIcon.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 20),
            infoIcon.centerXAnchor.constraint(equalTo: infoCard.centerXAnchor),
            
            // Info title
            infoTitle.topAnchor.constraint(equalTo: infoIcon.bottomAnchor, constant: 12),
            infoTitle.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoTitle.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            
            // Info description
            infoDescription.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 8),
            infoDescription.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoDescription.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoDescription.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func loginTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Заполните все поля")
            return
        }
        
        setLoading(true)
        hideError()
        
        apiManager.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                
                switch result {
                case .success(let user):
                    self?.dataManager.saveCurrentUser(user)
                    self?.navigateToTaskList()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func hideError() {
        errorContainerView.isHidden = true
    }
    
    private func setLoading(_ loading: Bool) {
        loginButton.isEnabled = !loading
        usernameTextField.isEnabled = !loading
        passwordTextField.isEnabled = !loading
        
        if loading {
            loginButton.setTitle("", for: .normal)
            loadingIndicator.startAnimating()
        } else {
            loginButton.setTitle("Войти", for: .normal)
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = "⚠️ \(message)"
        errorContainerView.isHidden = false
    }
    
    private func navigateToTaskList() {
        let taskListViewController = UIKitTaskListViewController()
        navigationController?.pushViewController(taskListViewController, animated: true)
    }
} 