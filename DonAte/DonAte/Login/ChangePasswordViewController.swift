//
//  ChangePasswordViewController.swift
//  DonAte
//
//  ✅ FIXED: Fully programmatic - no storyboard needed
//  ✅ FIXED: Black screen issue resolved
//  Updated: January 2, 2026
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    // MARK: - UI Properties (Programmatic)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let logoImageView = UIImageView()
    
    private let currentPasswordLabel = UILabel()
    private let currentPasswordTextField = UITextField()
    private let currentPasswordToggle = UIButton(type: .system)
    
    private let newPasswordLabel = UILabel()
    private let newPasswordTextField = UITextField()
    private let newPasswordToggle = UIButton(type: .system)
    
    private let confirmPasswordLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordToggle = UIButton(type: .system)
    
    private let passwordRequirementsLabel = UILabel()
    private let passwordStrengthView = UIView()
    private let passwordStrengthLabel = UILabel()
    
    private let changePasswordButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // Colors
    private let greenColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("✅ ChangePasswordViewController loaded")
        
        setupUI()
        setupConstraints()
        setupPasswordStrengthIndicator()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // CRITICAL: Set white background to fix black screen
        view.backgroundColor = .white
        title = "Change Password"
        
        // Add Green Header
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Add Logo
        logoImageView.image = UIImage(named: "DonAte_Logo_Transparent")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        scrollView.addSubview(contentView)
        
        // Current Password
        setupLabel(currentPasswordLabel, text: "Current Password")
        configureTextField(currentPasswordTextField, placeholder: "Enter current password", icon: "lock.fill", isSecure: true, toggleButton: currentPasswordToggle)
        
        // New Password
        setupLabel(newPasswordLabel, text: "New Password")
        configureTextField(newPasswordTextField, placeholder: "Enter new password", icon: "lock.fill", isSecure: true, toggleButton: newPasswordToggle)
        newPasswordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        
        // Confirm Password
        setupLabel(confirmPasswordLabel, text: "Confirm New Password")
        configureTextField(confirmPasswordTextField, placeholder: "Confirm new password", icon: "lock.fill", isSecure: true, toggleButton: confirmPasswordToggle)
        
        // Password Strength
        passwordStrengthView.translatesAutoresizingMaskIntoConstraints = false
        passwordStrengthView.layer.cornerRadius = 4
        passwordStrengthView.backgroundColor = .lightGray
        
        passwordStrengthLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordStrengthLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        passwordStrengthLabel.textAlignment = .center
        
        // Password Requirements
        passwordRequirementsLabel.text = """
        Password must contain:
        • At least 6 characters
        • At least one uppercase letter
        • At least one number
        """
        passwordRequirementsLabel.font = UIFont.systemFont(ofSize: 12)
        passwordRequirementsLabel.textColor = .gray
        passwordRequirementsLabel.numberOfLines = 0
        passwordRequirementsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to content view
        [currentPasswordLabel, currentPasswordTextField, currentPasswordToggle,
         newPasswordLabel, newPasswordTextField, newPasswordToggle,
         confirmPasswordLabel, confirmPasswordTextField, confirmPasswordToggle,
         passwordStrengthView, passwordStrengthLabel, passwordRequirementsLabel].forEach {
            contentView.addSubview($0)
        }
        
        // Change Password Button
        changePasswordButton.setTitle("Change Password", for: .normal)
        changePasswordButton.backgroundColor = greenColor
        changePasswordButton.setTitleColor(.white, for: .normal)
        changePasswordButton.layer.cornerRadius = 25
        changePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changePasswordButton)
        
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.setTitleColor(greenColor, for: .normal)
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = greenColor.cgColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, icon: String, isSecure: Bool, toggleButton: UIButton) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = isSecure
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add icon on left
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftContainer.addSubview(iconView)
        textField.leftView = leftContainer
        textField.leftViewMode = .always
        
        // Setup toggle button
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.setImage(UIImage(systemName: "eye"), for: .selected)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.tag = textField.tag
    }
    
    private func setupPasswordStrengthIndicator() {
        passwordStrengthView.layer.cornerRadius = 4
        passwordStrengthView.backgroundColor = .lightGray
        passwordStrengthLabel.text = ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: changePasswordButton.topAnchor, constant: -20),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Current Password
            currentPasswordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            currentPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentPasswordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            currentPasswordTextField.topAnchor.constraint(equalTo: currentPasswordLabel.bottomAnchor, constant: 8),
            currentPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: currentPasswordToggle.leadingAnchor, constant: -8),
            currentPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            currentPasswordToggle.centerYAnchor.constraint(equalTo: currentPasswordTextField.centerYAnchor),
            currentPasswordToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            currentPasswordToggle.widthAnchor.constraint(equalToConstant: 44),
            currentPasswordToggle.heightAnchor.constraint(equalToConstant: 44),
            
            // New Password
            newPasswordLabel.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 20),
            newPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            newPasswordTextField.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 8),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordTextField.trailingAnchor.constraint(equalTo: newPasswordToggle.leadingAnchor, constant: -8),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordToggle.centerYAnchor.constraint(equalTo: newPasswordTextField.centerYAnchor),
            newPasswordToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            newPasswordToggle.widthAnchor.constraint(equalToConstant: 44),
            newPasswordToggle.heightAnchor.constraint(equalToConstant: 44),
            
            // Password Strength
            passwordStrengthView.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 8),
            passwordStrengthView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordStrengthView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordStrengthView.heightAnchor.constraint(equalToConstant: 8),
            
            passwordStrengthLabel.topAnchor.constraint(equalTo: passwordStrengthView.bottomAnchor, constant: 4),
            passwordStrengthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordStrengthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Confirm Password
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordStrengthLabel.bottomAnchor, constant: 20),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: confirmPasswordToggle.leadingAnchor, constant: -8),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordToggle.centerYAnchor.constraint(equalTo: confirmPasswordTextField.centerYAnchor),
            confirmPasswordToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordToggle.widthAnchor.constraint(equalToConstant: 44),
            confirmPasswordToggle.heightAnchor.constraint(equalToConstant: 44),
            
            // Password Requirements
            passwordRequirementsLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            passwordRequirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordRequirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordRequirementsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Change Password Button
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            changePasswordButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -12),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Cancel Button
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        var textField: UITextField?
        if sender == currentPasswordToggle {
            textField = currentPasswordTextField
        } else if sender == newPasswordToggle {
            textField = newPasswordTextField
        } else if sender == confirmPasswordToggle {
            textField = confirmPasswordTextField
        }
        
        textField?.isSecureTextEntry.toggle()
    }
    
    @objc private func passwordTextChanged() {
        guard let password = newPasswordTextField.text else { return }
        updatePasswordStrength(password: password)
    }
    
    @objc private func changePasswordButtonTapped() {
        changePassword()
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Password Strength
    private func updatePasswordStrength(password: String) {
        let strength = calculatePasswordStrength(password: password)
        
        switch strength {
        case 0:
            passwordStrengthView.backgroundColor = .lightGray
            passwordStrengthLabel.text = ""
        case 1:
            passwordStrengthView.backgroundColor = .systemRed
            passwordStrengthLabel.text = "Weak"
            passwordStrengthLabel.textColor = .systemRed
        case 2:
            passwordStrengthView.backgroundColor = .systemOrange
            passwordStrengthLabel.text = "Fair"
            passwordStrengthLabel.textColor = .systemOrange
        case 3:
            passwordStrengthView.backgroundColor = .systemYellow
            passwordStrengthLabel.text = "Good"
            passwordStrengthLabel.textColor = .systemYellow
        default:
            passwordStrengthView.backgroundColor = .systemGreen
            passwordStrengthLabel.text = "Strong"
            passwordStrengthLabel.textColor = .systemGreen
        }
    }
    
    private func calculatePasswordStrength(password: String) -> Int {
        if password.isEmpty { return 0 }
        
        var strength = 0
        
        if password.count >= 6 { strength += 1 }
        if password.count >= 8 { strength += 1 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .lowercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil { strength += 1 }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")) != nil {
            strength += 1
        }
        
        return min(strength, 4)
    }
    
    // MARK: - Change Password
    private func changePassword() {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter your current password")
            return
        }
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter a new password")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, newPassword == confirmPassword else {
            showAlert(title: "Error", message: "New passwords do not match")
            return
        }
        
        guard validatePassword(newPassword) else {
            showAlert(title: "Error", message: "Password does not meet requirements")
            return
        }
        
        // Show loading
        showLoading(true)
        
        // Re-authenticate user first
        guard let user = Auth.auth().currentUser, let email = user.email else {
            showLoading(false)
            showAlert(title: "Error", message: "User not authenticated")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showLoading(false)
                    self.showAlert(title: "Error", message: "Current password is incorrect: \(error.localizedDescription)")
                }
                return
            }
            
            // Update password
            FirebaseManager.shared.changePassword(newPassword: newPassword) { error in
                DispatchQueue.main.async {
                    self.showLoading(false)
                    
                    if let error = error {
                        self.showAlert(title: "Error", message: "Failed to change password: \(error.localizedDescription)")
                    } else {
                        self.showAlert(title: "Success", message: "Password changed successfully") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    private func validatePassword(_ password: String) -> Bool {
        let hasMinLength = password.count >= 6
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasMinLength && hasUppercase && hasNumber
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            changePasswordButton.isEnabled = true
            changePasswordButton.alpha = 1.0
        }
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentPasswordTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            changePassword()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
