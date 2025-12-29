import UIKit

class CollectorRegistrationController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        sv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        iv.image = UIImage(systemName: "building.2.fill", withConfiguration: config)
        iv.tintColor = UIColor(hex: "#FF6B6B")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Register Organization"
        label.textColor = UIColor(hex: "#1A1A2E")
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an account for your food collection organization"
        label.textColor = UIColor(hex: "#6C757D")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let formStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(hex: "#FF6B6B")
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account? Log In"
        label.textColor = UIColor(hex: "#6C757D")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupKeyboardObservers()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerImageView, titleLabel, subtitleLabel, formStackView, registerButton, loginLabel].forEach {
            contentView.addSubview($0)
        }
        
        // Create form fields
        let fields: [(String, String, Bool)] = [
            ("Organization Name", "Enter organization name", false),
            ("Email Address", "Enter email address", true),
            ("Phone Number", "Enter phone number", false),
            ("Password", "Enter password", true),
            ("Confirm Password", "Confirm password", true)
        ]
        
        for (placeholder, title, isSecure) in fields {
            let fieldView = createTextField(title: title, placeholder: placeholder, isSecure: isSecure)
            formStackView.addArrangedSubview(fieldView)
        }
        
        // Add address and description text views
        let addressView = createTextView(title: "Address", placeholder: "Enter full address")
        formStackView.addArrangedSubview(addressView)
        
        let descriptionView = createTextView(title: "Description", placeholder: "Describe your organization and mission")
        formStackView.addArrangedSubview(descriptionView)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            headerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerImageView.widthAnchor.constraint(equalToConstant: 100),
            headerImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            formStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            registerButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 56),
            
            loginLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            loginLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 900)
        ])
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Collector Registration"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor(hex: "#1A1A2E")]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(hex: "#FF6B6B")
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helper Methods
    private func createTextField(title: String, placeholder: String, isSecure: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#6C757D")
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(hex: "#F8F9FA")
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        
        if isSecure {
            textField.isSecureTextEntry = true
        }
        
        container.addSubview(titleLabel)
        container.addSubview(textField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 52),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createTextView(title: String, placeholder: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#6C757D")
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = placeholder
        textView.textColor = UIColor(hex: "#ADB5BD")
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = UIColor(hex: "#F8F9FA")
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        
        container.addSubview(titleLabel)
        container.addSubview(textView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 120),
            textView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        dismissKeyboard()
        
        // Validate fields
        let formViews = formStackView.arrangedSubviews
        var isValid = true
        var errorMessage = ""
        
        for (index, view) in formViews.enumerated() {
            if let textField = view.subviews.compactMap({ $0 as? UITextField }).first {
                if let text = textField.text, text.isEmpty {
                    isValid = false
                    switch index {
                    case 0: errorMessage = "Please enter organization name"
                    case 1: errorMessage = "Please enter email address"
                    case 2: errorMessage = "Please enter phone number"
                    case 3: errorMessage = "Please enter password"
                    case 4: errorMessage = "Please confirm password"
                    default: break
                    }
                    break
                }
            }
        }
        
        // Check if password matches confirm password
        if let passwordField = formViews[3].subviews.compactMap({ $0 as? UITextField }).first,
           let confirmField = formViews[4].subviews.compactMap({ $0 as? UITextField }).first {
            if passwordField.text != confirmField.text {
                isValid = false
                errorMessage = "Passwords do not match"
            }
        }
        
        if !isValid {
            showAlert(title: "Validation Error", message: errorMessage)
            return
        }
        
        // Simulate registration
        showLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showLoading(false)
            self?.showAlert(title: "Success", message: "Your organization has been registered successfully!")
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoading(_ show: Bool) {
        registerButton.isEnabled = !show
        if show {
            registerButton.setTitle("Creating Account...", for: .normal)
            registerButton.backgroundColor = UIColor(hex: "#FF6B6B").withAlphaComponent(0.7)
        } else {
            registerButton.setTitle("Create Account", for: .normal)
            registerButton.backgroundColor = UIColor(hex: "#FF6B6B")
        }
    }
}
