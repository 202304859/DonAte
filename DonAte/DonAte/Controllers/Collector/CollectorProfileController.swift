//
//  CollectorProfileController.swift
//  DonAte
//
//  Created by BP-36-201-04 on 28/12/2025.
//

import UIKit

class CollectorProfileController: UIViewController {
    
    // MARK: - IBOutlets
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
    @IBOutlet weak var verificationStatusLabel: UILabel?
    @IBOutlet weak var verificationBadge: UIView?
    @IBOutlet weak var saveButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - UI Elements (Programmatic Mode)
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "building.2.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let organizationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verificationBadgeView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Form Fields
    private let registrationNumberField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Registration Number"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let contactPersonField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact Person Name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addressField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Address"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cityField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let websiteField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Website"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextViewField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionPlaceholderField: UILabel = {
        let label = UILabel()
        label.text = "Description of your organization..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButtonField: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicatorField: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private var profile: CollectorProfile?
    private var isStoryboardMode = false
    private var textFields: [UITextField] = []
    private var originalData: [String: Any] = [:]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if organizationNameTextField != nil {
            isStoryboardMode = true
            setupStoryboardUI()
        } else {
            setupUI()
        }
        
        setupKeyboardHandling()
        setupTapGesture()
        loadProfileData()
    }
    
    // MARK: - UI Setup (Storyboard Mode)
    private func setupStoryboardUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "My Profile"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        textFields = [organizationNameTextField, contactPersonTextField, emailTextField,
                      phoneTextField, addressTextField, cityTextField,
                      registrationNumberTextField, websiteTextField].compactMap { $0 }
        
        saveButton?.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        descriptionTextView?.delegate = self
        addDoneButtonToKeyboard()
    }
    
    // MARK: - UI Setup (Programmatic Mode)
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "My Profile"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        view.addSubview(programmaticScrollView)
        programmaticScrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(organizationLabel)
        headerView.addSubview(verificationBadgeView)
        contentView.addSubview(registrationNumberField)
        contentView.addSubview(contactPersonField)
        contentView.addSubview(emailField)
        contentView.addSubview(phoneField)
        contentView.addSubview(addressField)
        contentView.addSubview(cityField)
        contentView.addSubview(websiteField)
        contentView.addSubview(descriptionTextViewField)
        contentView.addSubview(descriptionPlaceholderField)
        contentView.addSubview(saveButtonField)
        contentView.addSubview(activityIndicatorField)
        
        textFields = [registrationNumberField, contactPersonField, emailField,
                      phoneField, addressField, cityField, websiteField]
        
        setupConstraints()
        saveButtonField.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        descriptionTextViewField.delegate = self
        addDoneButtonToKeyboard()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            programmaticScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            programmaticScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            programmaticScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            programmaticScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: programmaticScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: programmaticScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: programmaticScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: programmaticScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: programmaticScrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            organizationLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            organizationLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            organizationLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            verificationBadgeView.topAnchor.constraint(equalTo: organizationLabel.bottomAnchor, constant: 8),
            verificationBadgeView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            verificationBadgeView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            verificationBadgeView.heightAnchor.constraint(equalToConstant: 24),
            verificationBadgeView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            registrationNumberField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            registrationNumberField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registrationNumberField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            registrationNumberField.heightAnchor.constraint(equalToConstant: 50),
            
            contactPersonField.topAnchor.constraint(equalTo: registrationNumberField.bottomAnchor, constant: 15),
            contactPersonField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactPersonField.heightAnchor.constraint(equalToConstant: 50),
            
            emailField.topAnchor.constraint(equalTo: contactPersonField.bottomAnchor, constant: 15),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            phoneField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneField.heightAnchor.constraint(equalToConstant: 50),
            
            addressField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 15),
            addressField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressField.heightAnchor.constraint(equalToConstant: 50),
            
            cityField.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 15),
            cityField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cityField.heightAnchor.constraint(equalToConstant: 50),
            
            websiteField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 15),
            websiteField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            websiteField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            websiteField.heightAnchor.constraint(equalToConstant: 50),
            
            let descriptionLabel = UILabel()
            descriptionLabel.text = "Description"
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            descriptionLabel.textColor = .secondaryLabel
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(descriptionLabel)
            
            descriptionLabel.topAnchor.constraint(equalTo: websiteField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            descriptionTextViewField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextViewField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextViewField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextViewField.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionPlaceholderField.topAnchor.constraint(equalTo: descriptionTextViewField.topAnchor, constant: 8),
            descriptionPlaceholderField.leadingAnchor.constraint(equalTo: descriptionTextViewField.leadingAnchor, constant: 5),
            
            saveButtonField.topAnchor.constraint(equalTo: descriptionTextViewField.bottomAnchor, constant: 30),
            saveButtonField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButtonField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButtonField.heightAnchor.constraint(equalToConstant: 50),
            saveButtonField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            activityIndicatorField.centerXAnchor.constraint(equalTo: saveButtonField.centerXAnchor),
            activityIndicatorField.centerYAnchor.constraint(equalTo: saveButtonField.centerYAnchor),
        ])
    }
    
    // MARK: - Data Loading
    private func loadProfileData() {
        showLoading(true)
        
        let mockProfile = CollectorProfile()
        mockProfile.id = UUID().uuidString
        mockProfile.organizationName = "Food Bank Charity"
        mockProfile.contactPersonName = "John Smith"
        mockProfile.email = "contact@foodbank.org"
        mockProfile.phoneNumber = "+1 555-123-4567"
        mockProfile.address = "123 Charity Lane"
        mockProfile.city = "New York"
        mockProfile.registrationNumber = "REG-2024-001234"
        mockProfile.website = "www.foodbank.org"
        mockProfile.description = "We collect and distribute food to those in need."
        mockProfile.isVerified = true
        mockProfile.createdAt = Date()
        mockProfile.updatedAt = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.populateProfile(mockProfile)
            self?.showLoading(false)
        }
    }
    
    private func populateProfile(_ profile: CollectorProfile) {
        self.profile = profile
        
        if isStoryboardMode {
            organizationNameTextField?.text = profile.organizationName
            contactPersonTextField?.text = profile.contactPersonName
            emailTextField?.text = profile.email
            phoneTextField?.text = profile.phoneNumber
            addressTextField?.text = profile.address
            cityTextField?.text = profile.city
            registrationNumberTextField?.text = profile.registrationNumber
            websiteTextField?.text = profile.website
            descriptionTextView?.text = profile.description
            descriptionPlaceholder?.isHidden = !profile.description.isEmpty
            updateVerificationBadge(isVerified: profile.isVerified)
            storeOriginalData()
        } else {
            organizationLabel.text = profile.organizationName
            registrationNumberField.text = profile.registrationNumber
            contactPersonField.text = profile.contactPersonName
            emailField.text = profile.email
            phoneField.text = profile.phoneNumber
            addressField.text = profile.address
            cityField.text = profile.city
            websiteField.text = profile.website
            descriptionTextViewField.text = profile.description
            descriptionPlaceholderField.isHidden = !profile.description.isEmpty
            updateVerificationBadge(isVerified: profile.isVerified)
            storeOriginalData()
        }
    }
    
    private func updateVerificationBadge(isVerified: Bool) {
        if isStoryboardMode {
            verificationBadge?.backgroundColor = .systemGreen
            verificationStatusLabel?.text = "Verified"
            verificationStatusLabel?.textColor = .white
        } else {
            verificationBadgeView.text = isVerified ? "Verified" : "Pending Verification"
            verificationBadgeView.textColor = .white
            verificationBadgeView.backgroundColor = isVerified ? .systemGreen : .systemOrange
        }
    }
    
    private func storeOriginalData() {
        if isStoryboardMode {
            originalData = [
                "organizationName": organizationNameTextField?.text ?? "",
                "contactPersonName": contactPersonTextField?.text ?? "",
                "phoneNumber": phoneTextField?.text ?? "",
                "address": addressTextField?.text ?? "",
                "city": cityTextField?.text ?? "",
                "website": websiteTextField?.text ?? "",
                "description": descriptionTextView?.text ?? ""
            ]
        } else {
            originalData = [
                "organizationName": organizationLabel.text ?? "",
                "contactPersonName": contactPersonField.text ?? "",
                "phoneNumber": phoneField.text ?? "",
                "address": addressField.text ?? "",
                "city": cityField.text ?? "",
                "website": websiteField.text ?? "",
                "description": descriptionTextViewField.text ?? ""
            ]
        }
    }
    
    // MARK: - Actions
    @objc private func editButtonTapped() {
        setEditingEnabled(true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        if isStoryboardMode {
            organizationNameTextField?.becomeFirstResponder()
        } else {
            contactPersonField.becomeFirstResponder()
        }
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
        setEditingEnabled(false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard validateForm() else { return }
        
        showLoading(true)
        profile?.updateProfile(with: getCurrentFormData())
        profile?.updatedAt = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showLoading(false)
            self?.showSuccessMessage()
            self?.storeOriginalData()
        }
    }
    
    private func getCurrentFormData() -> [String: Any] {
        if isStoryboardMode {
            return [
                "organizationName": organizationNameTextField?.text ?? "",
                "contactPersonName": contactPersonTextField?.text ?? "",
                "phoneNumber": phoneTextField?.text ?? "",
                "address": addressTextField?.text ?? "",
                "city": cityTextField?.text ?? "",
                "website": websiteTextField?.text ?? "",
                "description": descriptionTextView?.text ?? ""
            ]
        } else {
            return [
                "organizationName": organizationLabel.text ?? "",
                "contactPersonName": contactPersonField.text ?? "",
                "phoneNumber": phoneField.text ?? "",
                "address": addressField.text ?? "",
                "city": cityField.text ?? "",
                "website": websiteField.text ?? "",
                "description": descriptionTextViewField.text ?? ""
            ]
        }
    }
    
    // MARK: - Validation
    private func validateForm() -> Bool {
        var errors: [String] = []
        
        let organizationName = isStoryboardMode ? organizationNameTextField?.text : organizationLabel.text
        let phoneNumber = isStoryboardMode ? phoneTextField?.text : phoneField.text
        let address = isStoryboardMode ? addressTextField?.text : addressField.text
        let city = isStoryboardMode ? cityTextField?.text : cityField.text
        
        if organizationName?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Organization name is required")
        }
        
        if phoneNumber?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Phone number is required")
        }
        
        if address?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Address is required")
        }
        
        if city?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("City is required")
        }
        
        if let website = isStoryboardMode ? websiteTextField?.text : websiteField.text, !website.isEmpty {
            if !isValidURL(website) {
                errors.append("Please enter a valid website URL")
            }
        }
        
        if !errors.isEmpty {
            showValidationError(errors.joined(separator: "\n"))
            return false
        }
        
        return true
    }
    
    private func isValidURL(_ url: String) -> Bool {
        let urlRegex = "https?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlPredicate.evaluate(with: url)
    }
    
    private func setEditingEnabled(_ enabled: Bool) {
        if isStoryboardMode {
            organizationNameTextField?.isUserInteractionEnabled = enabled
            contactPersonTextField?.isUserInteractionEnabled = enabled
            phoneTextField?.isUserInteractionEnabled = enabled
            addressTextField?.isUserInteractionEnabled = enabled
            cityTextField?.isUserInteractionEnabled = enabled
            websiteTextField?.isUserInteractionEnabled = enabled
            descriptionTextView?.isEditable = enabled
            saveButton?.isHidden = !enabled
            
            let borderColor: UIColor = enabled ? .systemBlue : .systemGray4
            organizationNameTextField?.layer.borderColor = borderColor.cgColor
            organizationNameTextField?.layer.borderWidth = enabled ? 1 : 0
        } else {
            contactPersonField.isUserInteractionEnabled = enabled
            phoneField.isUserInteractionEnabled = enabled
            addressField.isUserInteractionEnabled = enabled
            cityField.isUserInteractionEnabled = enabled
            websiteField.isUserInteractionEnabled = enabled
            descriptionTextViewField.isEditable = enabled
            saveButtonField.isHidden = !enabled
            
            let borderColor: UIColor = enabled ? .systemBlue : .clear
            contactPersonField.layer.borderColor = borderColor.cgColor
            contactPersonField.layer.borderWidth = enabled ? 1 : 0
        }
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
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - Alerts
    private func showValidationError(_ message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "Success", message: "Your profile has been updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoading(_ loading: Bool) {
        if isStoryboardMode {
            saveButton?.isEnabled = !loading
            if loading {
                saveButton?.setTitle("", for: .normal)
                activityIndicator?.startAnimating()
            } else {
                saveButton?.setTitle("Save Changes", for: .normal)
                activityIndicator?.stopAnimating()
            }
        } else {
            saveButtonField.isEnabled = !loading
            if loading {
                saveButtonField.setTitle("", for: .normal)
                activityIndicatorField.startAnimating()
            } else {
                saveButtonField.setTitle("Save Changes", for: .normal)
                activityIndicatorField.stopAnimating()
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension CollectorProfileController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if isStoryboardMode {
            descriptionPlaceholder?.isHidden = !textView.text.isEmpty
        } else {
            descriptionPlaceholderField.isHidden = !textView.text.isEmpty
        }
    }
}
