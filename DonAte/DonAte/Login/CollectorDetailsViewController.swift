//
//  CollectorDetailsViewController.swift
//  DonAte
//
//  ✅ FIXED: Pure programmatic navigation to UploadVerificationViewController
//  Updated: January 2, 2026
//

import UIKit

class CollectorDetailsViewController: UIViewController {
    
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    
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
    
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let pageControl = UIPageControl()
    
    // MARK: - Data Properties
    var organizationTypes: Set<String> = []
    var organizationData: [String: Any] = [:]
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        print("✅ CollectorDetailsViewController loaded")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Header
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        // Title
        titleLabel.text = "Collector Registration"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = darkGreen
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Scroll View
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
        setupTextField(contactPersonTextField, placeholder: "")
        
        // Add all to content view
        [organizationNameLabel, organizationNameTextField,
         organizationTypeLabel, charityCheckBox, communityServiceCheckBox, environmentalProtectionCheckBox,
         descriptionLabel, descriptionTextView,
         contactPersonLabel, contactPersonTextField].forEach {
            contentView.addSubview($0)
        }
        
        // Buttons
        setupButton(backButton, title: "Back", backgroundColor: .white, textColor: darkGreen, action: #selector(backTapped))
        setupButton(nextButton, title: "Next", backgroundColor: darkGreen, textColor: .white, action: #selector(nextTapped))
        
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        // Page Control
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = darkGreen
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = backgroundColor == .white ? 2 : 0
        button.layer.borderColor = darkGreen.cgColor
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),
            
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
            
            // Buttons
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Page Control
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
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
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextTapped() {
        // Validate
        guard let orgName = organizationNameTextField.text, !orgName.isEmpty else {
            showAlert(message: "Please enter organization name")
            return
        }
        
        guard !organizationTypes.isEmpty else {
            showAlert(message: "Please select one organization type")
            return
        }
        
        guard let contactPerson = contactPersonTextField.text, !contactPerson.isEmpty else {
            showAlert(message: "Please enter contact person name")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        if description.isEmpty || description == "A short description of the organization's mission and purpose." {
            showAlert(message: "Please enter organization description")
            return
        }
        
        // Save data
        organizationData = [
            "name": orgName,
            "types": Array(organizationTypes),
            "description": description,
            "contactPerson": contactPerson
        ]
        
        print("✅ Organization data validated:")
        print("   - Name: \(orgName)")
        print("   - Types: \(Array(organizationTypes))")
        print("   - Contact: \(contactPerson)")
        
        // ✅ FIXED: Create UploadVerificationViewController programmatically
        let uploadVC = UploadVerificationViewController()
        uploadVC.organizationData = organizationData
        navigationController?.pushViewController(uploadVC, animated: true)
        print("✅ Navigating to UploadVerificationViewController")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CollectorDetailsViewController: UITextViewDelegate {
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
