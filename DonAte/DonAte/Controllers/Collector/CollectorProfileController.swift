import UIKit

class CollectorProfileController: UIViewController {
    
    // MARK: - Properties
    private var profile: CollectorProfile
    private var isEditingMode = false
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Header
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#FF6B6B")
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "building.2.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor(hex: "#FF8787")
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private let organizationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // Stats Section
    private let statsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.05
        return view
    }()
    
    private let statsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 0
        return sv
    }()
    
    // Details Section
    private let detailsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        view.shadowOpacity = 0.05
        return view
    }()
    
    private let detailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    // Edit Button
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#FF6B6B")
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // Text Fields (for edit mode)
    private var contactEmailTextField: UITextField?
    private var phoneNumberTextField: UITextField?
    private var addressTextView: UITextView?
    private var descriptionTextView: UITextView?
    
    // Original values
    private var originalEmail: String = ""
    private var originalPhone: String = ""
    private var originalAddress: String = ""
    private var originalDescription: String = ""
    
    // MARK: - Initialization
    init(profile: CollectorProfile = CollectorProfile()) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTextFields()
        loadProfileData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView, statsContainerView, detailsContainerView, actionButton].forEach {
            contentView.addSubview($0)
        }
        
        // Header setup
        [profileImageView, organizationNameLabel].forEach {
            headerView.addSubview($0)
        }
        
        // Stats setup
        let statsData = [
            ("Total Pickups", "1,234"),
            ("Active Donors", "56"),
            ("Rating", "4.8")
        ]
        
        for (title, value) in statsData {
            let statView = createStatItem(title: title, value: value)
            statsStackView.addArrangedSubview(statView)
        }
        statsContainerView.addSubview(statsStackView)
        
        // Details setup
        let detailsTitles = ["Contact Email", "Phone Number", "Address", "Description"]
        for title in detailsTitles {
            let detailView = createDetailItem(title: title)
            detailsStackView.addArrangedSubview(detailView)
        }
        detailsContainerView.addSubview(detailsStackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            organizationNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            organizationNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            organizationNameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            organizationNameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            statsContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            statsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor),
            statsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            detailsContainerView.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 20),
            detailsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            detailsStackView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor),
            
            actionButton.topAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 800)
        ])
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "My Profile"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#FF6B6B")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTextFields() {
        // Find and configure text fields
        for case let stackView as UIStackView in detailsContainerView.subviews {
            for case let view as UIView in stackView.arrangedSubviews {
                for case let label as UILabel in view.subviews {
                    if let textField = view.subviews.compactMap({ $0 as? UITextField }).first {
                        switch label.text {
                        case "Contact Email":
                            contactEmailTextField = textField
                        case "Phone Number":
                            phoneNumberTextField = textField
                        default:
                            break
                        }
                    } else if let textView = view.subviews.compactMap({ $0 as? UITextView }).first {
                            switch label.text {
                            case "Address":
                                addressTextView = textView
                            case "Description":
                                descriptionTextView = textView
                            default:
                                break
                            }
                        }
                }
            }
        }
    }
    
    private func loadProfileData() {
        organizationNameLabel.text = profile.organizationName
        originalEmail = profile.contactEmail
        originalPhone = profile.phoneNumber
        originalAddress = profile.address
        originalDescription = profile.description
        
        updateDetailValue("Contact Email", value: profile.contactEmail)
        updateDetailValue("Phone Number", value: profile.phoneNumber)
        updateDetailValue("Address", value: profile.address)
        updateDetailValue("Description", value: profile.description)
    }
    
    private func updateDetailValue(_ title: String, value: String) {
        for case let stackView as UIStackView in detailsContainerView.subviews {
            for case let view as UIView in stackView.arrangedSubviews {
                for case let label as UILabel in view.subviews {
                    if label.text == title {
                        // Remove existing value labels
                        view.subviews.filter { $0.tag == 100 }.forEach { $0.removeFromSuperview() }
                        
                        let valueLabel = UILabel()
                        valueLabel.tag = 100
                        valueLabel.translatesAutoresizingMaskIntoConstraints = false
                        valueLabel.text = value
                        valueLabel.textColor = UIColor(hex: "#1A1A2E")
                        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                        valueLabel.numberOfLines = 0
                        view.addSubview(valueLabel)
                        
                        if let titleLabel = view.subviews.first as? UILabel {
                            NSLayoutConstraint.activate([
                                valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                                valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
                            ])
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func createStatItem(title: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: "#FF6B6B")
        valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#6C757D")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        
        container.addSubview(valueLabel)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func createDetailItem(title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#6C757D")
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        if title == "Address" || title == "Description" {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.textColor = UIColor(hex: "#1A1A2E")
            textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
            container.addSubview(titleLabel)
            container.addSubview(textView)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                
                textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
                textView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
                textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])
            
            // Add separator
            addSeparator(to: container)
        } else {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.textColor = UIColor(hex: "#1A1A2E")
            textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            textField.isEnabled = false
            
            container.addSubview(titleLabel)
            container.addSubview(textField)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                
                textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
                textField.heightAnchor.constraint(equalToConstant: 44),
                textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
            ])
            
            addSeparator(to: container)
        }
        
        return container
    }
    
    private func addSeparator(to view: UIView) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hex: "#E9ECEF")
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped() {
        if !isEditingMode {
            // Enter edit mode
            isEditingMode = true
            actionButton.setTitle("Save Changes", for: .normal)
            enableEditing()
            showCancelButton()
        } else {
            // Save changes
            saveChanges()
            isEditingMode = false
            actionButton.setTitle("Edit Profile", for: .normal)
            disableEditing()
            hideCancelButton()
        }
    }
    
    @objc private func cancelButtonTapped() {
        // Revert changes
        profile.contactEmail = originalEmail
        profile.phoneNumber = originalPhone
        profile.address = originalAddress
        profile.description = originalDescription
        
        loadProfileData()
        
        isEditingMode = false
        actionButton.setTitle("Edit Profile", for: .normal)
        disableEditing()
        hideCancelButton()
    }
    
    private func enableEditing() {
        contactEmailTextField?.isEnabled = true
        phoneNumberTextField?.isEnabled = true
        addressTextView?.isEditable = true
        descriptionTextView?.isEditable = true
        
        contactEmailTextField?.borderStyle = .roundedRect
        phoneNumberTextField?.borderStyle = .roundedRect
        addressTextView?.layer.borderColor = UIColor(hex: "#E9ECEF")?.cgColor
        addressTextView?.layer.borderWidth = 1
        addressTextView?.layer.cornerRadius = 8
        descriptionTextView?.layer.borderColor = UIColor(hex: "#E9ECEF")?.cgColor
        descriptionTextView?.layer.borderWidth = 1
        descriptionTextView?.layer.cornerRadius = 8
        
        contactEmailTextField?.becomeFirstResponder()
    }
    
    private func disableEditing() {
        contactEmailTextField?.isEnabled = false
        phoneNumberTextField?.isEnabled = false
        addressTextView?.isEditable = false
        descriptionTextView?.isEditable = false
        
        contactEmailTextField?.borderStyle = .none
        phoneNumberTextField?.borderStyle = .none
        addressTextView?.layer.borderWidth = 0
        descriptionTextView?.layer.borderWidth = 0
    }
    
    private func showCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func hideCancelButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    private func saveChanges() {
        profile.contactEmail = contactEmailTextField?.text ?? ""
        profile.phoneNumber = phoneNumberTextField?.text ?? ""
        profile.address = addressTextView?.text ?? ""
        profile.description = descriptionTextView?.text ?? ""
        
        // Update original values
        originalEmail = profile.contactEmail
        originalPhone = profile.phoneNumber
        originalAddress = profile.address
        originalDescription = profile.description
        
        loadProfileData()
        
        // Show success message
        let alert = UIAlertController(title: "Success", message: "Your profile has been updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
