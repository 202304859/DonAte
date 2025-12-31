//
//  LoginViewController.swift
//  DonAte
//
//  FIXED: Register button navigation
//  December 31, 2025
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets (Connect these to your storyboard)
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ONLY add the green header - don't touch anything else
        addSimpleGreenHeader()
        
        // Style your existing storyboard elements
        styleUI()
        setupKeyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Green Header (Simple Version)
    private func addSimpleGreenHeader() {
        // Calculate top quarter of screen
        let screenHeight = UIScreen.main.bounds.height
        let headerHeight = screenHeight * 0.15
        
        // Create green view
        let greenView = UIView()
        greenView.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        greenView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
        
        // Add it BEHIND everything
        view.insertSubview(greenView, at: 0)
    }
    
    // MARK: - Style UI
    private func styleUI() {
        // Don't move anything - just style the colors
        let greenColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Style login button
        loginButton?.backgroundColor = greenColor
        loginButton?.setTitleColor(.white, for: .normal)
        loginButton?.layer.cornerRadius = 25
        
        // Style register button
        registerButton?.layer.cornerRadius = 25
        registerButton?.layer.borderWidth = 2
        registerButton?.layer.borderColor = greenColor.cgColor
        registerButton?.setTitleColor(greenColor, for: .normal)
        
        // Style forgot password button
        forgotPasswordButton?.setTitleColor(greenColor, for: .normal)
        
        // Add password toggle if needed
        addPasswordToggle()
        
        activityIndicator?.isHidden = true
    }
    
    private func addPasswordToggle() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)
        
        passwordTextField?.rightView = containerView
        passwordTextField?.rightViewMode = .always
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        emailTextField?.delegate = self
        passwordTextField?.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performLogin()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // ✅ FIXED: Don't call performSegue here!
        // The segue is already connected in the storyboard directly to the button
        // So this action will trigger, then the segue will automatically fire
        // Just leave this empty or use it for analytics/tracking
        print("📱 Register button tapped - navigating to ChooseRole")
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        showForgotPasswordAlert()
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField?.isSecureTextEntry.toggle()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Login Logic
    private func performLogin() {
        guard let email = emailTextField?.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        guard let password = passwordTextField?.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your password")
            return
        }
        
        showLoading(true)
        
        FirebaseManager.shared.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showLoading(false)
                
                switch result {
                case .success(let profile):
                    FirebaseManager.shared.updateLastLogin(uid: profile.uid)
                    // Navigate to Profile using the storyboard segue
                    self.performSegue(withIdentifier: "showProfileFromLogin", sender: nil)
                    
                case .failure(let error):
                    self.showAlert(title: "Login Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showForgotPasswordAlert() {
        let alert = UIAlertController(title: "Reset Password",
                                     message: "Enter your email address to receive a password reset link",
                                     preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(title: "Error", message: "Please enter your email address")
                return
            }
            self?.sendPasswordResetEmail(email: email)
        })
        
        present(alert, animated: true)
    }
    
    private func sendPasswordResetEmail(email: String) {
        showLoading(true)
        
        FirebaseManager.shared.resetPassword(email: email) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showLoading(false)
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Password reset email sent. Please check your inbox.")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
            loginButton?.isEnabled = false
            loginButton?.alpha = 0.5
            registerButton?.isEnabled = false
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            loginButton?.isEnabled = true
            loginButton?.alpha = 1.0
            registerButton?.isEnabled = true
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField?.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            performLogin()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
