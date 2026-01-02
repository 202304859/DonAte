//
//  RegistrationViewController.swift
//  DonAte
//
//  ✅ FIXED: Complete organization data upload for collectors
//  ✅ FIXED: Uses Cloudinary for verification images
//  Updated: January 2, 2026
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets (from storyboard)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var termsCheckBox: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var userRole: String = "donor" // Set by ChooseRoleViewController
    var organizationData: [String: Any] = [:] // Set by CollectorDetailsViewController
    var verificationImage: UIImage? // Set by UploadVerificationViewController
    
    private var termsAccepted = false
    private let datePicker = UIDatePicker()
    private let greenColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0) // #B4E7B4
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("✅ Registration for: \(userRole.uppercased())")
        if !organizationData.isEmpty {
            print("📋 Organization data received: \(organizationData)")
        }
        if verificationImage != nil {
            print("🖼️ Verification image received")
        }
        
        addGreenHeader()
        setupUI()
        setupDatePicker()
        setupKeyboardHandling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            self?.fixScrollViewContentSize()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fixScrollViewContentSize()
    }
    
    // MARK: - Add Green Header
    private func addGreenHeader() {
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 140)
        view.insertSubview(headerView, at: 0)
    }
    
    // MARK: - Scroll View Fix
    private func fixScrollViewContentSize() {
        guard let scrollView = scrollView else { return }
        
        var maxY: CGFloat = 0
        
        func findMaxY(in view: UIView) {
            for subview in view.subviews {
                let frame = scrollView.convert(subview.frame, from: subview.superview)
                let bottom = frame.maxY
                
                if bottom > maxY {
                    maxY = bottom
                }
                
                findMaxY(in: subview)
            }
        }
        
        findMaxY(in: scrollView)
        maxY += 100
        
        let newContentSize = CGSize(width: scrollView.bounds.width, height: max(maxY, 800))
        
        if scrollView.contentSize != newContentSize {
            scrollView.contentSize = newContentSize
            print("✅ ScrollView contentSize: \(newContentSize)")
        }
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Register as \(userRole.capitalized)"
        
        // Configure text fields
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
        registerButton?.backgroundColor = greenColor
        registerButton?.setTitle("REGISTER", for: .normal)
        registerButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Configure terms checkbox
        termsCheckBox?.setImage(UIImage(systemName: "square"), for: .normal)
        termsCheckBox?.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        termsCheckBox?.tintColor = greenColor
        
        activityIndicator?.isHidden = true
        
        scrollView?.isScrollEnabled = true
        scrollView?.showsVerticalScrollIndicator = true
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, icon: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = isSecure
        textField.delegate = self
        textField.autocapitalizationType = .none
        
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
        print("Terms accepted: \(termsAccepted)")
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        validateAndRegister()
    }
    
    @IBAction func viewTermsButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Terms of Service", message: "Please read and accept our Terms of Service to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 20, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeField = findFirstResponder(in: view) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let rect = scrollView.convert(activeField.frame, from: activeField.superview)
                var visibleRect = rect
                visibleRect.origin.y -= 20
                visibleRect.size.height += 40
                scrollView.scrollRectToVisible(visibleRect, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView?.contentInset = .zero
        scrollView?.scrollIndicatorInsets = .zero
    }
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        return nil
    }
    
    // MARK: - Validation & Registration
    private func validateAndRegister() {
        scrollView?.setContentOffset(.zero, animated: true)
        
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
        
        let userType: UserType = userRole == "collector" ? .collector : .donor
        print("🎯 Registering as: \(userType)")
        
        showLoading(true)
        
        FirebaseManager.shared.registerUser(email: email, password: password, fullName: fullName, userType: userType) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var profile):
                // Update profile with additional data
                profile.phoneNumber = self.phoneNumberTextField?.text
                profile.location = self.locationTextField?.text
                profile.dateOfBirth = self.datePicker.date
                
                // Update user profile first
                FirebaseManager.shared.updateUserProfile(profile) { updateResult in
                    switch updateResult {
                    case .success:
                        print("✅ User profile updated")
                        
                        // If collector, save organization data
                        if self.userRole == "collector" {
                            self.saveCollectorData(uid: profile.uid)
                        } else {
                            self.completeRegistration()
                        }
                        
                    case .failure(let error):
                        print("⚠️ Profile update failed: \(error.localizedDescription)")
                        // Still try to save collector data if applicable
                        if self.userRole == "collector" {
                            self.saveCollectorData(uid: profile.uid)
                        } else {
                            self.completeRegistration()
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showLoading(false)
                    print("❌ Registration failed: \(error.localizedDescription)")
                    self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func saveCollectorData(uid: String) {
        print("📋 Saving collector data for UID: \(uid)")
        
        // First, upload verification image if present
        if let verificationImage = verificationImage {
            print("🖼️ Uploading verification document...")
            FirebaseManager.shared.uploadVerificationDocument(uid: uid, image: verificationImage) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let imageURL):
                    print("✅ Verification document uploaded: \(imageURL)")
                    self.organizationData["verificationDocumentURL"] = imageURL
                    self.saveOrganizationDataToFirestore(uid: uid)
                    
                case .failure(let error):
                    print("⚠️ Verification document upload failed: \(error.localizedDescription)")
                    // Continue without verification document
                    self.saveOrganizationDataToFirestore(uid: uid)
                }
            }
        } else {
            print("ℹ️ No verification document to upload")
            saveOrganizationDataToFirestore(uid: uid)
        }
    }
    
    private func saveOrganizationDataToFirestore(uid: String) {
        guard !organizationData.isEmpty else {
            print("⚠️ No organization data to save")
            completeRegistration()
            return
        }
        
        print("💾 Saving organization data to Firestore...")
        FirebaseManager.shared.saveOrganizationData(uid: uid, organizationData: organizationData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("✅ Organization data saved successfully")
                self.completeRegistration()
                
            case .failure(let error):
                print("❌ Organization data save failed: \(error.localizedDescription)")
                // Still complete registration
                self.completeRegistration()
            }
        }
    }
    
    private func completeRegistration() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoading(false)
            
            print("✅ Registration complete!")
            self.showAlert(title: "Success", message: "Registration successful!") {
                // Navigate to Profile screen using segue
                self.performSegue(withIdentifier: "showProfile", sender: nil)
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
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let scrollView = scrollView else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let rect = scrollView.convert(textField.frame, from: textField.superview)
            var visibleRect = rect
            visibleRect.origin.y -= 20
            visibleRect.size.height += 40
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
    }
}
