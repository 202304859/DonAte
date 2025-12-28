//
//  CollectorRegistrationController.swift
//  DonAte
//
//  Created by BP-36-201-04 on 03/12/2025.
//

import UIKit

class CollectorRegistrationController: UIViewController {
    
    // MARK: - IBOutlets (for Storyboard mode)
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var organizationNameTextField: UITextField?
    @IBOutlet weak var contactPersonTextField: UITextField?
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var phoneTextField: UITextField?
    @IBOutlet weak var addressTextField: UITextField?
    @IBOutlet weak var cityTextField: UITextField?
    @IBOutlet weak var registrationNumberTextField: UITextField?
    @IBOutlet weak var websiteTextField: UITextField?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var descriptionPlaceholder: UILabel?
    @IBOutlet weak var termsSwitch: UISwitch?
    @IBOutlet weak var termsLabel: UILabel?
    @IBOutlet weak var registerButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - UI Elements (Programmatic mode)
    private let programmaticScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Collector Registration"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register your organization to start accepting donations"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Form Fields
    private let programmaticOrganizationNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Organization Name *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticContactPersonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact Person Name *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticEmailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Address *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticCityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticRegistrationNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Registration Number *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .allCharacters
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticWebsiteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Website (Optional)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let programmaticDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let programmaticDescriptionPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Description of your organization..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let programmaticTermsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let programmaticTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "I agree to the Terms and Conditions *"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let programmaticRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let programmaticActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private var textFields: [UITextField] = []
    private var isStoryboardMode = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if we're in storyboard mode (IBOutlets are connected)
        if organizationNameTextField != nil {
            isStoryboardMode = true
            setupStoryboardUI()
        } else {
            setupUI()
        }
        
        setupKeyboardHandling()
        setupTapGesture()
    }
    
    // MARK: - UI Setup (Storyboard Mode)
    private func setupStoryboardUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Collector Registration"
        
        // Collect text fields
        textFields = [organizationNameTextField, contactPersonTextField, emailTextField,
                      phoneTextField, addressTextField, cityTextField,
                      registrationNumberTextField, websiteTextField].compactMap { $0 }
        
        // Setup button action
        registerButton?.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        // Setup text view delegate
        descriptionTextView?.delegate = self
        
        // Setup tap gesture for terms label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        termsLabel?.addGestureRecognizer(tapGesture)
        
        // Add Done button to keyboard for text fields
        addDoneButtonToKeyboard()
    }
    
    // MARK: - UI Setup (Programmatic Mode)
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Collector Registration"
        
        // Add subviews
        view.addSubview(programmaticScrollView)
        programmaticScrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(programmaticOrganizationNameTextField)
        contentView.addSubview(programmaticContactPersonTextField)
        contentView.addSubview(programmaticEmailTextField)
        contentView.addSubview(programmaticPhoneTextField)
        contentView.addSubview(programmaticAddressTextField)
        contentView.addSubview(programmaticCityTextField)
        contentView.addSubview(programmaticRegistrationNumberTextField)
        contentView.addSubview(programmaticWebsiteTextField)
        contentView.addSubview(programmaticDescriptionTextView)
        contentView.addSubview(programmaticDescriptionPlaceholder)
        contentView.addSubview(programmaticTermsSwitch)
        contentView.addSubview(programmaticTermsLabel)
        contentView.addSubview(programmaticRegisterButton)
        contentView.addSubview(programmaticActivityIndicator)
        
        // Collect text fields
        textFields = [programmaticOrganizationNameTextField, programmaticContactPersonTextField, programmaticEmailTextField,
                      programmaticPhoneTextField, programmaticAddressTextField, programmaticCityTextField,
                      programmaticRegistrationNumberTextField, programmaticWebsiteTextField]
        
        // Setup constraints
        setupConstraints()
        
        // Setup button action
        programmaticRegisterButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        // Setup text view delegate
        programmaticDescriptionTextView.delegate = self
        
        // Setup tap gesture for terms label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        programmaticTermsLabel.addGestureRecognizer(tapGesture)
        
        // Add Done button to keyboard for text fields
        addDoneButtonToKeyboard()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            programmaticScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            programmaticScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            programmaticScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            programmaticScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: programmaticScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: programmaticScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: programmaticScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: programmaticScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: programmaticScrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Organization Name
            programmaticOrganizationNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            programmaticOrganizationNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticOrganizationNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticOrganizationNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Contact Person
            programmaticContactPersonTextField.topAnchor.constraint(equalTo: programmaticOrganizationNameTextField.bottomAnchor, constant: 15),
            programmaticContactPersonTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticContactPersonTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticContactPersonTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email
            programmaticEmailTextField.topAnchor.constraint(equalTo: programmaticContactPersonTextField.bottomAnchor, constant: 15),
            programmaticEmailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticEmailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticEmailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Phone
            programmaticPhoneTextField.topAnchor.constraint(equalTo: programmaticEmailTextField.bottomAnchor, constant: 15),
            programmaticPhoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticPhoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticPhoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Address
            programmaticAddressTextField.topAnchor.constraint(equalTo: programmaticPhoneTextField.bottomAnchor, constant: 15),
            programmaticAddressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticAddressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticAddressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // City
            programmaticCityTextField.topAnchor.constraint(equalTo: programmaticAddressTextField.bottomAnchor, constant: 15),
            programmaticCityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticCityTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticCityTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Registration Number
            programmaticRegistrationNumberTextField.topAnchor.constraint(equalTo: programmaticCityTextField.bottomAnchor, constant: 15),
            programmaticRegistrationNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticRegistrationNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticRegistrationNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Website
            programmaticWebsiteTextField.topAnchor.constraint(equalTo: programmaticRegistrationNumberTextField.bottomAnchor, constant: 15),
            programmaticWebsiteTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticWebsiteTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticWebsiteTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Description Label
            let descriptionLabel = UILabel()
            descriptionLabel.text = "Description"
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            descriptionLabel.textColor = .secondaryLabel
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(descriptionLabel)
            
            descriptionLabel.topAnchor.constraint(equalTo: programmaticWebsiteTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Description Text View
            programmaticDescriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            programmaticDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticDescriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Description Placeholder
            programmaticDescriptionPlaceholder.topAnchor.constraint(equalTo: programmaticDescriptionTextView.topAnchor, constant: 8),
            programmaticDescriptionPlaceholder.leadingAnchor.constraint(equalTo: programmaticDescriptionTextView.leadingAnchor, constant: 5),
            
            // Terms Switch
            programmaticTermsSwitch.topAnchor.constraint(equalTo: programmaticDescriptionTextView.bottomAnchor, constant: 20),
            programmaticTermsSwitch.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Terms Label
            programmaticTermsLabel.centerYAnchor.constraint(equalTo: programmaticTermsSwitch.centerYAnchor),
            programmaticTermsLabel.leadingAnchor.constraint(equalTo: programmaticTermsSwitch.trailingAnchor, constant: 10),
            programmaticTermsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Register Button
            programmaticRegisterButton.topAnchor.constraint(equalTo: programmaticTermsLabel.bottomAnchor, constant: 30),
            programmaticRegisterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            programmaticRegisterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            programmaticRegisterButton.heightAnchor.constraint(equalToConstant: 50),
            programmaticRegisterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            // Activity Indicator
            programmaticActivityIndicator.centerXAnchor.constraint(equalTo: programmaticRegisterButton.centerXAnchor),
            programmaticActivityIndicator.centerYAnchor.constraint(equalTo: programmaticRegisterButton.centerYAnchor),
        ])
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        
        if isStoryboardMode {
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
        } else {
            programmaticScrollView.contentInset = contentInsets
            programmaticScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if isStoryboardMode {
            scrollView?.contentInset = .zero
            scrollView?.scrollIndicatorInsets = .zero
        } else {
            programmaticScrollView.contentInset = .zero
            programmaticScrollView.scrollIndicatorInsets = .zero
        }
    }
    
    private func addDoneButtonToKeyboard() {
        for textField in textFields {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [flexibleSpace, doneButton]
            textField.inputAccessoryView = toolbar
        }
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard validateForm() else { return }
        
        showLoading(true)
        
        let profile = CollectorProfile()
        profile.id = UUID().uuidString
        profile.organizationName = organizationNameTextField?.text ?? programmaticOrganizationNameTextField.text ?? ""
        profile.contactPersonName = contactPersonTextField?.text ?? programmaticContactPersonTextField.text ?? ""
        profile.email = emailTextField?.text ?? programmaticEmailTextField.text ?? ""
        profile.phoneNumber = phoneTextField?.text ?? programmaticPhoneTextField.text ?? ""
        profile.address = addressTextField?.text ?? programmaticAddressTextField.text ?? ""
        profile.city = cityTextField?.text ?? programmaticCityTextField.text ?? ""
        profile.registrationNumber = registrationNumberTextField?.text ?? programmaticRegistrationNumberTextField.text ?? ""
        profile.website = websiteTextField?.text ?? programmaticWebsiteTextField.text
        profile.description = descriptionTextView?.text ?? programmaticDescriptionTextView.text
        profile.isVerified = false
        profile.createdAt = Date()
        profile.updatedAt = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showLoading(false)
            self?.showSuccessAlert(profile: profile)
        }
    }
    
    @objc private func termsLabelTapped() {
        showTermsAndConditions()
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        var errors: [String] = []
        
        if organizationNameTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticOrganizationNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("Organization name is required")
        }
        
        if contactPersonTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticContactPersonTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("Contact person name is required")
        }
        
        if let email = organizationNameTextField != nil ? emailTextField?.text : programmaticEmailTextField.text, !isValidEmail(email ?? "") {
            errors.append("Please enter a valid email address")
        }
        
        if phoneTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticPhoneTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("Phone number is required")
        }
        
        if addressTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticAddressTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("Address is required")
        }
        
        if cityTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticCityTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("City is required")
        }
        
        if registrationNumberTextField?.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? (programmaticRegistrationNumberTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            errors.append("Registration number is required")
        }
        
        if !(termsSwitch?.isOn ?? programmaticTermsSwitch.isOn) {
            errors.append("You must agree to the Terms and Conditions")
        }
        
        if !errors.isEmpty {
            showValidationError(errors.joined(separator: "\n"))
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Alerts
    private func showValidationError(_ message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(profile: CollectorProfile) {
        let alert = UIAlertController(
            title: "Registration Successful",
            message: "Your organization has been registered successfully. Please wait for verification.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigateToLogin()
        })
        present(alert, animated: true)
    }
    
    private func showTermsAndConditions() {
        let alert = UIAlertController(
            title: "Terms and Conditions",
            message: "By registering as a collector, you agree to:\n\n1. Provide accurate organization information\n2. Use donations only for intended charitable purposes\n3. Maintain proper food safety standards\n4. Report any issues promptly\n5. Respect donor privacy",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "I Agree", style: .default) { [weak self] _ in
            if self?.isStoryboardMode == true {
                self?.termsSwitch?.isOn = true
            } else {
                self?.programmaticTermsSwitch.isOn = true
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showLoading(_ loading: Bool) {
        if isStoryboardMode {
            registerButton?.isEnabled = !loading
            if loading {
                registerButton?.setTitle("", for: .normal)
                activityIndicator?.startAnimating()
            } else {
                registerButton?.setTitle("Register", for: .normal)
                activityIndicator?.stopAnimating()
            }
        } else {
            programmaticRegisterButton.isEnabled = !loading
            if loading {
                programmaticRegisterButton.setTitle("", for: .normal)
                programmaticActivityIndicator.startAnimating()
            } else {
                programmaticRegisterButton.setTitle("Register", for: .normal)
                programmaticActivityIndicator.stopAnimating()
            }
        }
    }
    
    private func navigateToLogin() {
        if let dashboardController = storyboard?.instantiateViewController(withIdentifier: "CollectorDashboardController") {
            navigationController?.setViewControllers([dashboardController], animated: true)
        }
    }
}

// MARK: - UITextViewDelegate
extension CollectorRegistrationController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if isStoryboardMode {
            descriptionPlaceholder?.isHidden = !textView.text.isEmpty
        } else {
            programmaticDescriptionPlaceholder.isHidden = !textView.text.isEmpty
        }
    }
}

