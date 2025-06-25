import UIKit

class UIKitTaskListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let actionStackView = UIStackView()
    private let loadFromAPIButton = UIButton(type: .system)
    private let addTaskButton = UIButton(type: .system)
    
    private let errorContainerView = UIView()
    private let errorLabel = UILabel()
    private let errorCloseButton = UIButton(type: .system)
    
    private let loadingView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    
    private let emptyStateView = UIView()
    private let emptyIcon = UILabel()
    private let emptyTitleLabel = UILabel()
    private let emptyDescriptionLabel = UILabel()
    
    private var tasks: [TaskModel] = []
    private let apiManager = APIManager.shared
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadTasks()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "UIKit"
        navigationItem.largeTitleDisplayMode = .always
        
        // Logout button
        let logoutButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = logoutButton
        
        // Header view
        headerView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        headerView.layer.cornerRadius = 12
        
        titleLabel.text = "📝 Задачи"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        
        subtitleLabel.text = "UIKit + URLSession + UserDefaults"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        
        // Action buttons
        actionStackView.axis = .horizontal
        actionStackView.distribution = .fillEqually
        actionStackView.spacing = 8
        
        loadFromAPIButton.setTitle("☁️ Из API", for: .normal)
        loadFromAPIButton.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        loadFromAPIButton.setTitleColor(.systemGreen, for: .normal)
        loadFromAPIButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        loadFromAPIButton.layer.cornerRadius = 8
        loadFromAPIButton.layer.borderWidth = 1
        loadFromAPIButton.layer.borderColor = UIColor.systemGreen.cgColor
        loadFromAPIButton.addTarget(self, action: #selector(loadFromAPITapped), for: .touchUpInside)
        
        addTaskButton.setTitle("➕ Добавить", for: .normal)
        addTaskButton.backgroundColor = .systemGreen
        addTaskButton.setTitleColor(.white, for: .normal)
        addTaskButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        addTaskButton.layer.cornerRadius = 8
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        
        actionStackView.addArrangedSubview(loadFromAPIButton)
        actionStackView.addArrangedSubview(addTaskButton)
        
        // Error container (hidden by default)
        errorContainerView.backgroundColor = .systemRed.withAlphaComponent(0.1)
        errorContainerView.layer.cornerRadius = 12
        errorContainerView.isHidden = true
        
        errorLabel.font = .systemFont(ofSize: 14, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        
        errorCloseButton.setTitle("Закрыть", for: .normal)
        errorCloseButton.setTitleColor(.systemRed, for: .normal)
        errorCloseButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        errorCloseButton.addTarget(self, action: #selector(hideError), for: .touchUpInside)
        
        // Loading view (hidden by default)
        loadingView.isHidden = true
        loadingIndicator.hidesWhenStopped = true
        loadingLabel.text = "Загрузка через URLSession..."
        loadingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        loadingLabel.textColor = .secondaryLabel
        
        // Empty state view
        emptyIcon.text = "📋"
        emptyIcon.font = .systemFont(ofSize: 48)
        emptyIcon.textAlignment = .center
        
        emptyTitleLabel.text = "Нет задач"
        emptyTitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.textColor = .label
        
        emptyDescriptionLabel.text = "Добавьте новую или загрузите из API"
        emptyDescriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        emptyDescriptionLabel.textAlignment = .center
        emptyDescriptionLabel.textColor = .secondaryLabel
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UIKitTaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // Add subviews
        view.addSubview(headerView)
        view.addSubview(errorContainerView)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(emptyStateView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(actionStackView)
        
        errorContainerView.addSubview(errorLabel)
        errorContainerView.addSubview(errorCloseButton)
        
        loadingView.addSubview(loadingIndicator)
        loadingView.addSubview(loadingLabel)
        
        emptyStateView.addSubview(emptyIcon)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptyDescriptionLabel)
    }
    
    private func setupConstraints() {
        [headerView, errorContainerView, tableView, loadingView, emptyStateView, titleLabel, subtitleLabel, actionStackView, errorLabel, errorCloseButton, loadingIndicator, loadingLabel, emptyIcon, emptyTitleLabel, emptyDescriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Header view
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // Subtitle  
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // Action stack
            actionStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            actionStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            actionStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            actionStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            actionStackView.heightAnchor.constraint(equalToConstant: 36),
            
            // Error container
            errorContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            errorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Error label
            errorLabel.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 12),
            errorLabel.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: -12),
            
            // Error close button
            errorCloseButton.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 12),
            errorCloseButton.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -12),
            errorCloseButton.leadingAnchor.constraint(greaterThanOrEqualTo: errorLabel.trailingAnchor, constant: 8),
            errorCloseButton.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: -12),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: loadingView.topAnchor, constant: -8),
            
            // Loading view
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loadingView.heightAnchor.constraint(equalToConstant: 44),
            
            // Loading indicator
            loadingIndicator.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 16),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 16),
            
            // Loading label
            loadingLabel.leadingAnchor.constraint(equalTo: loadingIndicator.trailingAnchor, constant: 8),
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor),
            
            // Empty state view
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: tableView.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: tableView.trailingAnchor, constant: -20),
            
            // Empty icon
            emptyIcon.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyIcon.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            
            // Empty title
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyIcon.bottomAnchor, constant: 16),
            emptyTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            // Empty description
            emptyDescriptionLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 4),
            emptyDescriptionLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyDescriptionLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyDescriptionLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func loadTasks() {
        tasks = dataManager.loadTasks()
        updateUI()
    }
    
    private func updateUI() {
        tableView.reloadData()
        emptyStateView.isHidden = !tasks.isEmpty
        tableView.isHidden = tasks.isEmpty
    }
    
    @objc private func addTaskTapped() {
        let alert = UIAlertController(title: "➕ Новая задача", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Изучить UIKit..."
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Подробности задачи..."
        }
        
        let createAction = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let titleField = alert.textFields?.first,
                  let descriptionField = alert.textFields?.last,
                  let title = titleField.text, !title.isEmpty else {
                return
            }
            
            let description = descriptionField.text ?? ""
            let newTask = TaskModel(title: title, description: description)
            
            self?.tasks.append(newTask)
            self?.dataManager.saveTasks(self?.tasks ?? [])
            self?.updateUI()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func loadFromAPITapped() {
        setLoading(true)
        hideError()
        
        apiManager.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                
                switch result {
                case .success(let apiTasks):
                    self?.tasks = apiTasks
                    self?.dataManager.saveTasks(apiTasks)
                    self?.updateUI()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func hideError() {
        errorContainerView.isHidden = true
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.dataManager.logout()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func setLoading(_ loading: Bool) {
        loadFromAPIButton.isEnabled = !loading
        addTaskButton.isEnabled = !loading
        
        if loading {
            loadingView.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingView.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = "⚠️ \(message)"
        errorContainerView.isHidden = false
    }
    
    private func toggleTask(at index: Int) {
        guard index < tasks.count else { return }
        tasks[index].isCompleted.toggle()
        dataManager.saveTasks(tasks)
        updateUI()
    }
}

// MARK: - UITableViewDataSource
extension UIKitTaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! UIKitTaskCell
        cell.configure(with: tasks[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UIKitTaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UIKitTaskCellDelegate
extension UIKitTaskListViewController: UIKitTaskCellDelegate {
    func taskCell(_ cell: UIKitTaskCell, didToggleTaskAt indexPath: IndexPath) {
        toggleTask(at: indexPath.row)
    }
}

// MARK: - Custom UITableViewCell
protocol UIKitTaskCellDelegate: AnyObject {
    func taskCell(_ cell: UIKitTaskCell, didToggleTaskAt indexPath: IndexPath)
}

class UIKitTaskCell: UITableViewCell {
    weak var delegate: UIKitTaskCellDelegate?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let checkboxButton = UIButton(type: .system)
    
    private var task: TaskModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Container view
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        // Title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        
        // Description label
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.numberOfLines = 0
        
        // Checkbox button
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        // Add subviews
        contentView.addSubview(containerView)
        [checkboxButton, titleLabel, descriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [containerView, titleLabel, descriptionLabel, checkboxButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Checkbox button
            checkboxButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            checkboxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with task: TaskModel) {
        self.task = task
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        guard let task = task else { return }
        
        let checkboxImage = task.isCompleted ? "checkmark.circle.fill" : "circle"
        checkboxButton.setImage(UIImage(systemName: checkboxImage), for: .normal)
        checkboxButton.tintColor = task.isCompleted ? .systemBlue : .systemGray3
        
        if task.isCompleted {
            containerView.backgroundColor = .systemGray6
            titleLabel.textColor = .secondaryLabel
            descriptionLabel.textColor = .tertiaryLabel
        } else {
            containerView.backgroundColor = .systemBackground
            titleLabel.textColor = .label
            descriptionLabel.textColor = .secondaryLabel
        }
        
        // Add border
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = task.isCompleted ? UIColor.clear.cgColor : UIColor.systemGray5.cgColor
    }
    
    @objc private func checkboxTapped() {
        guard let indexPath = getIndexPath() else { return }
        delegate?.taskCell(self, didToggleTaskAt: indexPath)
    }
    
    private func getIndexPath() -> IndexPath? {
        guard let tableView = superview as? UITableView else { return nil }
        return tableView.indexPath(for: self)
    }
} 