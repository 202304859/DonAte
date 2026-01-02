//
//  OrganizationDetailsViewController.swift
//  DonAte
//
//  Updated to match CollectorDetailsViewController style
//  Updated: January 2, 2026
//

import UIKit
import FirebaseFirestore

class OrganizationDetailsViewController: UIViewController {
    
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let organizationNameLabel = UILabel()
    private let organizationNameTextField = UITextField()
    
    private let organizationTypeLabel = UILabel()
    private let charityCheckBox = UIButton(type: .system)
    private let communityServiceCheckBox = UIButton(type: .system)
    private let environmentalProtectionCheckBox = UIButton(type: .system)
    
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let contactPersonLabel = UILabel()
    private let contactPersonTextField = UITextField()
    
    private let saveButton = UIButton(type: .system)
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    
    // MARK: - Data Properties
    var userProfile: UserProfile?
    private var organizationData: [String: Any]?
    private var organizationTypes: Set<String> = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadOrganizationData()
        print("✅ OrganizationDetailsViewController loaded")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Organization Name
        setupLabel(organizationNameLabel, text: "Organization Name")
        setupTextField(organizationNameTextField, placeholder: "Full name of the organization.")
        
        // Organization Type
        setupLabel(organizationTypeLabel, text: "Organization Type")
        setupCheckBox(charityCheckBox, title: "Charity", action: #selector(charityTapped))
        setupCheckBox(communityServiceCheckBox, title: "Community Service", action: #selector(communityServiceTapped))
        setupCheckBox(environmentalProtectionCheckBox, title: "Environmental Protection", action: #selector(environmentalProtectionTapped))
        
        // Description
        setupLabel(descriptionLabel, text: "Description")
        setupTextView(descriptionTextView)
        
        // Contact Person
        setupLabel(contactPersonLabel, text: "Contact Person")
        setupTextField(contactPersonTextField, placeholder: "John Doe")
        
        // Add all to content view
        [organizationNameLabel, organizationNameTextField,
         organizationTypeLabel, charityCheckBox, communityServiceCheckBox, environmentalProtectionCheckBox,
         descriptionLabel, descriptionTextView,
         contactPersonLabel, contactPersonTextField].forEach {
            contentView.addSubview($0)
        }
        
        // Save Button
        setupButton(saveButton, title: "Save", backgroundColor: darkGreen, textColor: .white, action: #selector(saveTapped))
        view.addSubview(saveButton)
        
        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCheckBox(_ button: UIButton, title: String, action: Selector) {
        // Create a container configuration
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .darkGray
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = config
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Set images for normal and selected states
        let normalImage = UIImage(systemName: "square")?.withTintColor(darkGreen, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "checkmark.square")?.withTintColor(darkGreen, renderingMode: .alwaysOriginal)
        
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
    }
    
    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "A short description of the organization's mission and purpose."
        textView.textColor = .lightGray
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor, textColor: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Organization Name
            organizationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            organizationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            organizationNameTextField.topAnchor.constraint(equalTo: organizationNameLabel.bottomAnchor, constant: 8),
            organizationNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            organizationNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Organization Type
            organizationTypeLabel.topAnchor.constraint(equalTo: organizationNameTextField.bottomAnchor, constant: 20),
            organizationTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            charityCheckBox.topAnchor.constraint(equalTo: organizationTypeLabel.bottomAnchor, constant: 8),
            charityCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charityCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            charityCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            communityServiceCheckBox.topAnchor.constraint(equalTo: charityCheckBox.bottomAnchor, constant: 8),
            communityServiceCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            communityServiceCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            communityServiceCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            environmentalProtectionCheckBox.topAnchor.constraint(equalTo: communityServiceCheckBox.bottomAnchor, constant: 8),
            environmentalProtectionCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            environmentalProtectionCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            environmentalProtectionCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: environmentalProtectionCheckBox.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Contact Person
            contactPersonLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            contactPersonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactPersonTextField.topAnchor.constraint(equalTo: contactPersonLabel.bottomAnchor, constant: 8),
            contactPersonTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactPersonTextField.heightAnchor.constraint(equalToConstant: 50),
            contactPersonTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Save Button
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadOrganizationData() {
        guard let uid = FirebaseManager.shared.currentUser?.uid else { return }
        
        activityIndicator.startAnimating()
        
        FirebaseManager.shared.fetchOrganizationData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let data):
                    self.organizationData = data
                    self.populateFields(with: data)
                    print("✅ Organization data loaded")
                case .failure(let error):
                    print("❌ Failed to load data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func populateFields(with data: [String: Any]) {
        if let name = data["name"] as? String {
            organizationNameTextField.text = name
        }
        
        if let types = data["types"] as? [String], let firstType = types.first {
            organizationTypes = Set([firstType])
            
            // Deselect all first
            charityCheckBox.isSelected = false
            communityServiceCheckBox.isSelected = false
            environmentalProtectionCheckBox.isSelected = false
            
            // Select only the first type
            switch firstType {
            case "Charity":
                charityCheckBox.isSelected = true
            case "Community Service":
                communityServiceCheckBox.isSelected = true
            case "Environmental Protection":
                environmentalProtectionCheckBox.isSelected = true
            default:
                break
            }
        }
        
        if let description = data["description"] as? String, !description.isEmpty {
            descriptionTextView.text = description
            descriptionTextView.textColor = .black
        }
        
        if let contactPerson = data["contactPerson"] as? String {
            contactPersonTextField.text = contactPerson
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
    
    // MARK: - Actions
    @objc private func charityTapped() {
        // Deselect all checkboxes
        charityCheckBox.isSelected = false
        communityServiceCheckBox.isSelected = false
        environmentalProtectionCheckBox.isSelected = false
        
        // Select only this one
        charityCheckBox.isSelected = true
        
        // Clear and set the organization type
        organizationTypes.removeAll()
        organizationTypes.insert("Charity")
    }
    
    @objc private func communityServiceTapped() {
        // Deselect all checkboxes
        charityCheckBox.isSelected = false
        communityServiceCheckBox.isSelected = false
        environmentalProtectionCheckBox.isSelected = false
        
        // Select only this one
        communityServiceCheckBox.isSelected = true
        
        // Clear and set the organization type
        organizationTypes.removeAll()
        organizationTypes.insert("Community Service")
    }
    
    @objc private func environmentalProtectionTapped() {
        // Deselect all checkboxes
        charityCheckBox.isSelected = false
        communityServiceCheckBox.isSelected = false
        environmentalProtectionCheckBox.isSelected = false
        
        // Select only this one
        environmentalProtectionCheckBox.isSelected = true
        
        // Clear and set the organization type
        organizationTypes.removeAll()
        organizationTypes.insert("Environmental Protection")
    }
    
    @objc private func saveTapped() {
        guard let name = organizationNameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter organization name")
            return
        }
        
        guard !organizationTypes.isEmpty else {
            showAlert(title: "Error", message: "Please select at least one organization type")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        if description.isEmpty || description == "A short description of the organization's mission and purpose." {
            showAlert(title: "Error", message: "Please enter a description")
            return
        }
        
        guard let contactPerson = contactPersonTextField.text, !contactPerson.isEmpty else {
            showAlert(title: "Error", message: "Please enter contact person name")
            return
        }
        
        saveData(name: name, types: Array(organizationTypes), description: description, contactPerson: contactPerson)
    }
    
    private func saveData(name: String, types: [String], description: String, contactPerson: String) {
        guard let uid = FirebaseManager.shared.currentUser?.uid else { return }
        
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        
        var orgData = organizationData ?? [:]
        orgData["name"] = name
        orgData["types"] = types
        orgData["description"] = description
        orgData["contactPerson"] = contactPerson
        orgData["updatedAt"] = Timestamp(date: Date())
        
        FirebaseManager.shared.saveOrganizationData(uid: uid, organizationData: orgData) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.saveButton.isEnabled = true
                
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Organization details saved successfully") {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to save: \(error.localizedDescription)")
                }
            }
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

// MARK: - UITextViewDelegate
extension OrganizationDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "A short description of the organization's mission and purpose."
            textView.textColor = .lightGray
        }
    }
}
