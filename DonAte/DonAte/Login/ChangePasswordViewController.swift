//
//  ChangePasswordViewController.swift
//  DonAte
//
//  Created by Claude on 30/12/2025.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordStrengthView: UIView!
    @IBOutlet weak var passwordStrengthLabel: UILabel!
    @IBOutlet weak var passwordRequirementsLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPasswordStrengthIndicator()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Change Password"
        
        // Configure text fields
        configureTextField(currentPasswordTextField, placeholder: "Current Password", icon: "lock.fill", isSecure: true)
        configureTextField(newPasswordTextField, placeholder: "New Password", icon: "lock.fill", isSecure: true)
        configureTextField(confirmPasswordTextField, placeholder: "Confirm New Password", icon: "lock.fill", isSecure: true)
        
        // Add show/hide password buttons
        addPasswordToggle(to: currentPasswordTextField)
        addPasswordToggle(to: newPasswordTextField)
        addPasswordToggle(to: confirmPasswordTextField)
        
        // Configure buttons
        changePasswordButton.layer.cornerRadius = 25
        changePasswordButton.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
        cancelButton.setTitleColor(UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0), for: .normal)
        
        // Password requirements - FIXED CHARACTER ENCODING
        passwordRequirementsLabel.text = """
        Password must contain:
        • At least 6 characters
        • At least one uppercase letter
        • At least one number
        """
        passwordRequirementsLabel.font = UIFont.systemFont(ofSize: 12)
        passwordRequirementsLabel.textColor = .gray
        
        activityIndicator.isHidden = true
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, icon: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = isSecure
        textField.delegate = self
        
        // Add icon
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        containerView.addSubview(iconView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        // Add text change observer for new password
        if textField == newPasswordTextField {
            textField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        }
    }
    
    private func addPasswordToggle(to textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)
        
        textField.rightView = containerView
        textField.rightViewMode = .always
    }
    
    private func setupPasswordStrengthIndicator() {
        passwordStrengthView.layer.cornerRadius = 4
        passwordStrengthView.backgroundColor = .lightGray
        passwordStrengthLabel.text = ""
    }
    
    // MARK: - Actions
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        changePassword()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let textField = sender.superview?.superview as? UITextField {
            textField.isSecureTextEntry.toggle()
        }
    }
    
    @objc private func passwordTextChanged() {
        guard let password = newPasswordTextField.text else { return }
        updatePasswordStrength(password: password)
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
                            self.dismiss(animated: true)
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
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            changePasswordButton.isEnabled = true
            changePasswordButton.alpha = 1.0
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
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
