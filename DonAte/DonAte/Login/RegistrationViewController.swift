//
//  RegistrationViewController.swift
//  DonAte
//
//  ✅ DEBUG VERSION: Find which outlet is nil
//  December 31, 2025
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var termsCheckBox: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var userRole: String = "donor" // ✅ Set by ChooseRoleViewController
    private var termsAccepted = false
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ✅ DEBUG: Check which outlet is nil
        print("🔍 Checking outlets...")
        print("scrollView: \(scrollView != nil ? "✅" : "❌ NIL")")
        print("fullNameTextField: \(fullNameTextField != nil ? "✅" : "❌ NIL")")
        print("emailTextField: \(emailTextField != nil ? "✅" : "❌ NIL")")
        print("phoneNumberTextField: \(phoneNumberTextField != nil ? "✅" : "❌ NIL")")
        print("passwordTextField: \(passwordTextField != nil ? "✅" : "❌ NIL")")
        print("confirmPasswordTextField: \(confirmPasswordTextField != nil ? "✅" : "❌ NIL")")
        print("locationTextField: \(locationTextField != nil ? "✅" : "❌ NIL")")
        print("dateOfBirthTextField: \(dateOfBirthTextField != nil ? "✅" : "❌ NIL")")
        print("userTypeSegmentedControl: \(userTypeSegmentedControl != nil ? "✅" : "❌ NIL")")
        print("termsCheckBox: \(termsCheckBox != nil ? "✅" : "❌ NIL")")
        print("registerButton: \(registerButton != nil ? "✅" : "❌ NIL")")
        print("activityIndicator: \(activityIndicator != nil ? "✅" : "❌ NIL")")
        
        // ✅ Print the received role for debugging
        print("✅ RegistrationViewController loaded with role: \(userRole)")
        
        setupUI()
        setupDatePicker()
        setupKeyboardHandling()
        
        // ✅ Pre-select the segmented control based on the role
        setUserTypeFromRole()
    }
    
    // MARK: - Setup
    
    // ✅ NEW: Pre-select segmented control based on role from ChooseRoleViewController
    private func setUserTypeFromRole() {
        guard let segmentedControl = userTypeSegmentedControl else {
            print("⚠️ userTypeSegmentedControl is nil, skipping role selection")
            return
        }
        
        if userRole == "collector" {
            segmentedControl.selectedSegmentIndex = 1
            print("📌 Pre-selected: Collector")
        } else {
            segmentedControl.selectedSegmentIndex = 0
            print("📌 Pre-selected: Donor")
        }
    }
    
    private func setupUI() {
        // Configure text fields - with nil checks
        if let textField = fullNameTextField {
            setupTextField(textField, placeholder: "Full Name", icon: "person.fill")
        }
        if let textField = emailTextField {
            setupTextField(textField, placeholder: "Email", icon: "envelope.fill")
        }
        if let textField = phoneNumberTextField {
            setupTextField(textField, placeholder: "Phone Number", icon: "phone.fill")
        }
        if let textField = passwordTextField {
            setupTextField(textField, placeholder: "Password", icon: "lock.fill", isSecure: true)
        }
        if let textField = confirmPasswordTextField {
            setupTextField(textField, placeholder: "Confirm Password", icon: "lock.fill", isSecure: true)
        }
        if let textField = locationTextField {
            setupTextField(textField, placeholder: "Location", icon: "location.fill")
        }
        if let textField = dateOfBirthTextField {
            setupTextField(textField, placeholder: "Date of Birth", icon: "calendar")
        }
        
        // Configure register button
        registerButton?.layer.cornerRadius = 25
        registerButton?.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Configure terms checkbox
        termsCheckBox?.setImage(UIImage(systemName: "square"), for: .normal)
        termsCheckBox?.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        termsCheckBox?.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Configure user type segmented control
        userTypeSegmentedControl?.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        userTypeSegmentedControl?.selectedSegmentTintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        activityIndicator?.isHidden = true
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, icon: String, isSecure: Bool = false) {
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
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        dateOfBirthTextField?.inputView = datePicker
        dateOfBirthTextField?.inputAccessoryView = toolbar
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @IBAction func termsCheckBoxTapped(_ sender: UIButton) {
        termsAccepted.toggle()
        sender.isSelected = termsAccepted
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        validateAndRegister()
    }
    
    @IBAction func viewTermsButtonTapped(_ sender: UIButton) {
        // Navigate to Terms of Service screen
        performSegue(withIdentifier: "showTermsSegue", sender: nil)
    }
    
    @IBAction func backToLoginTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func datePickerDone() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateOfBirthTextField?.text = dateFormatter.string(from: datePicker.date)
        dateOfBirthTextField?.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let scrollView = scrollView else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView?.contentInset = .zero
        scrollView?.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Validation & Registration
    private func validateAndRegister() {
        guard let fullName = fullNameTextField?.text, !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your full name")
            return
        }
        
        guard let email = emailTextField?.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        guard let password = passwordTextField?.text, !password.isEmpty, password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField?.text, password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        guard termsAccepted else {
            showAlert(title: "Error", message: "Please accept the Terms of Service")
            return
        }
        
        // ✅ Get user type from segmented control (which was pre-selected based on userRole)
        let userType: UserType
        switch userTypeSegmentedControl?.selectedSegmentIndex ?? 0 {
        case 0:
            userType = .donor
            print("🎯 Registering as: Donor")
        case 1:
            userType = .collector
            print("🎯 Registering as: Collector")
        default:
            userType = .donor
            print("🎯 Registering as: Donor (default)")
        }
        
        // Show loading
        showLoading(true)
        
        // Register user
        FirebaseManager.shared.registerUser(email: email, password: password, fullName: fullName, userType: userType) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showLoading(false)
                
                switch result {
                case .success(var profile):
                    // Update additional profile info
                    profile.phoneNumber = self.phoneNumberTextField?.text
                    profile.location = self.locationTextField?.text
                    profile.dateOfBirth = self.datePicker.date
                    
                    print("✅ User registered successfully as: \(userType)")
                    
                    // Save updated profile
                    FirebaseManager.shared.updateUserProfile(profile) { updateResult in
                        switch updateResult {
                        case .success:
                            self.showAlert(title: "Success", message: "Registration successful!") {
                                // Navigate to Profile
                                self.performSegue(withIdentifier: "showProfile", sender: nil)
                            }
                        case .failure(let error):
                            self.showAlert(title: "Warning", message: "Account created but profile update failed: \(error.localizedDescription)") {
                                // Still navigate to Profile even if update failed
                                self.performSegue(withIdentifier: "showProfile", sender: nil)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Registration failed: \(error.localizedDescription)")
                    self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
            registerButton?.isEnabled = false
            registerButton?.alpha = 0.5
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            registerButton?.isEnabled = true
            registerButton?.alpha = 1.0
        }
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
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            emailTextField?.becomeFirstResponder()
        case emailTextField:
            phoneNumberTextField?.becomeFirstResponder()
        case phoneNumberTextField:
            passwordTextField?.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField?.becomeFirstResponder()
        case confirmPasswordTextField:
            locationTextField?.becomeFirstResponder()
        case locationTextField:
            dateOfBirthTextField?.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
