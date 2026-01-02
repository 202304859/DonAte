//
//  OrganizationDetailsViewController.swift
//  DonAte
//
//  View and edit organization details for collectors
//  January 2, 2026
//

import UIKit
import FirebaseFirestore

class OrganizationDetailsViewController: UIViewController {
    
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let organizationNameLabel = UILabel()
    private let organizationNameField = UILabel()
    
    private let organizationTypeLabel = UILabel()
    private let organizationTypeField = UILabel()
    
    private let descriptionLabel = UILabel()
    private let descriptionField = UILabel()
    
    private let contactPersonLabel = UILabel()
    private let contactPersonField = UILabel()
    
    private let verificationStatusLabel = UILabel()
    private let verificationBadge = UIView()
    private let verificationStatusField = UILabel()
    
    private let editButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Data Properties
    var userProfile: UserProfile?
    private var organizationData: OrganizationData?
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadOrganizationData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Organization Details"
        
        // Add green header
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Organization Name
        setupField(label: organizationNameLabel, field: organizationNameField, title: "Organization Name")
        
        // Organization Type
        setupField(label: organizationTypeLabel, field: organizationTypeField, title: "Organization Type")
        
        // Description
        setupField(label: descriptionLabel, field: descriptionField, title: "Description")
        descriptionField.numberOfLines = 0
        
        // Contact Person
        setupField(label: contactPersonLabel, field: contactPersonField, title: "Contact Person")
        
        // Verification Status
        setupField(label: verificationStatusLabel, field: verificationStatusField, title: "Verification Status")
        
        // Verification Badge
        verificationBadge.translatesAutoresizingMaskIntoConstraints = false
        verificationBadge.layer.cornerRadius = 12
        contentView.addSubview(verificationBadge)
        
        verificationStatusField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        verificationStatusField.textColor = .white
        
        // Add all to content view
        [organizationNameLabel, organizationNameField,
         organizationTypeLabel, organizationTypeField,
         descriptionLabel, descriptionField,
         contactPersonLabel, contactPersonField,
         verificationStatusLabel, verificationBadge].forEach {
            contentView.addSubview($0)
        }
        
        verificationBadge.addSubview(verificationStatusField)
        
        // Edit button
        editButton.setTitle("Edit Organization Details", for: .normal)
        editButton.backgroundColor = darkGreen
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.layer.cornerRadius = 25
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        
        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupField(label: UILabel, field: UILabel, title: String) {
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Organization Name
            organizationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            organizationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            organizationNameField.topAnchor.constraint(equalTo: organizationNameLabel.bottomAnchor, constant: 8),
            organizationNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Organization Type
            organizationTypeLabel.topAnchor.constraint(equalTo: organizationNameField.bottomAnchor, constant: 20),
            organizationTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            organizationTypeField.topAnchor.constraint(equalTo: organizationTypeLabel.bottomAnchor, constant: 8),
            organizationTypeField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationTypeField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: organizationTypeField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Contact Person
            contactPersonLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 20),
            contactPersonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactPersonField.topAnchor.constraint(equalTo: contactPersonLabel.bottomAnchor, constant: 8),
            contactPersonField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Verification Status
            verificationStatusLabel.topAnchor.constraint(equalTo: contactPersonField.bottomAnchor, constant: 20),
            verificationStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verificationStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            verificationBadge.topAnchor.constraint(equalTo: verificationStatusLabel.bottomAnchor, constant: 8),
            verificationBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verificationBadge.heightAnchor.constraint(equalToConstant: 32),
            verificationBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            verificationBadge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            verificationStatusField.centerYAnchor.constraint(equalTo: verificationBadge.centerYAnchor),
            verificationStatusField.leadingAnchor.constraint(equalTo: verificationBadge.leadingAnchor, constant: 12),
            verificationStatusField.trailingAnchor.constraint(equalTo: verificationBadge.trailingAnchor, constant: -12),
            
            // Edit button
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Loading
    private func loadOrganizationData() {
        guard let uid = FirebaseManager.shared.currentUser?.uid else {
            showAlert(message: "User not logged in")
            return
        }
        
        activityIndicator.startAnimating()
        
        let db = Firestore.firestore()
        db.collection("organizations").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    print("❌ Error loading organization: \(error.localizedDescription)")
                    self.showNoOrganizationState()
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("ℹ️ No organization data found")
                    self.showNoOrganizationState()
                    return
                }
                
                self.organizationData = OrganizationData(data: data)
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        guard let org = organizationData else { return }
        
        organizationNameField.text = org.name
        organizationTypeField.text = org.types.joined(separator: ", ")
        descriptionField.text = org.description
        contactPersonField.text = org.contactPerson
        
        if org.isVerified {
            verificationStatusField.text = "✓ Verified"
            verificationBadge.backgroundColor = .systemGreen
        } else {
            verificationStatusField.text = "⏳ Pending Verification"
            verificationBadge.backgroundColor = .systemOrange
        }
    }
    
    private func showNoOrganizationState() {
        organizationNameField.text = "Not registered as organization"
        organizationTypeField.text = "-"
        descriptionField.text = "Please contact support to register your organization"
        contactPersonField.text = "-"
        verificationStatusField.text = "Not Verified"
        verificationBadge.backgroundColor = .systemGray
        editButton.isEnabled = false
        editButton.alpha = 0.5
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        let alert = UIAlertController(
            title: "Edit Organization",
            message: "To update your organization details, please contact support at support@donate-app.com",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Organization Data Model
struct OrganizationData {
    let name: String
    let types: [String]
    let description: String
    let contactPerson: String
    let isVerified: Bool
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? "Unknown"
        self.types = data["types"] as? [String] ?? []
        self.description = data["description"] as? String ?? ""
        self.contactPerson = data["contactPerson"] as? String ?? "Unknown"
        self.isVerified = data["isVerified"] as? Bool ?? false
    }
}
