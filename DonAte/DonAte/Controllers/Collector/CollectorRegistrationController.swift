///
//  CollectorRegistrationController.swift
//  DonAte
//
//  Contrôleur d'inscription Collector multi-étapes
//  Conformément aux spécifications du PDF DonAte
//

import UIKit

/// Étapes de l'inscription Collector
enum RegistrationStep {
    case organizationInfo      // Nom, Type, Description, Contact Person
    case contactInfo           // Email, Phone, Building, PO Box, Registration, Document Upload
    case pickupSchedule        // Everyday/Weekly, Jours de collecte
    case password              // Mot de passe et confirmation
    case completion            // Succès
}

/// Contrôleur d'inscription Collector avec flux multi-étapes
class CollectorRegistrationController: UIViewController {
    
    // MARK: - Propriétés
    
    private var currentStep: RegistrationStep = .organizationInfo
    private var registrationData = CollectorProfile()
    private var selectedOrganizationType: OrganizationType = .charity
    private var selectedPickupDays: Set<WeekDay> = []
    private var selectedPickupFrequency: PickupFrequency = .weekly
    
    // MARK: - UI Components - Navigation Personnalisée
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    // MARK: - UI Components - Conteneur Principal
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Components - Indicateur d'étapes
    
    private lazy var stepIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stepLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - UI Components - Étape 1: Informations Organisation
    
    private lazy var organizationInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    private lazy var organizationNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Organization Name *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var organizationTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization Type *"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var organizationTypeSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Charity", "Community Service", "Environmental Protection"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(organizationTypeChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description *"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var descriptionPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "A short description of the organization's mission and purpose."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactPersonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact Person *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - UI Components - Étape 2: Coordonnées
    
    private lazy var contactInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact Email *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact Phone Number *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buildingNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Building no. *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var poBoxTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "P.O Box no. *"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var registrationNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Registration Number *"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .allCharacters
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var uploadDocumentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadDocumentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var uploadDocumentLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload a Verification Document"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var termsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(termsSwitchChanged), for: .valueChanged)
        return toggle
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Agree to Terms & Conditions *"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - UI Components - Étape 3: Planification
    
    private lazy var pickupScheduleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var pickupFrequencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Pickup Frequency"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pickupFrequencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Everyday", "Weekly"])
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(pickupFrequencyChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var pickupDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Pickup Days"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pickupDaysStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var dayButtons: [UIButton] = []
    
    // MARK: - UI Components - Étape 4: Mot de passe
    
    private lazy var passwordContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password * (must contain 8 characters)"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password *"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - UI Components - Étape 5: Succès
    
    private lazy var completionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var successTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration Completed Successfully!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var successMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for registering! Your registration request has been successfully approved by the admin team."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goToDashboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Dashboard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToDashboardTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UI Components - Boutons de Navigation
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, nextButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
        setupTapGesture()
        updateUIForCurrentStep()
    }
    
    // MARK: - Configuration de l'interface utilisateur
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Ajouter la barre de navigation personnalisée
        view.addSubview(customNavBar)
        
        // Configurer la barre de navigation
        customNavBar.configure(style: .backWithTitle(title: "NGO Register"), rightButtonAction: nil)
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Ajouter le scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Ajouter les conteneurs d'étapes
        contentView.addSubview(stepIndicatorView)
        stepIndicatorView.addSubview(stepLabelsStack)
        
        setupStepIndicator()
        setupOrganizationInfoContainer()
        setupContactInfoContainer()
        setupPickupScheduleContainer()
        setupPasswordContainer()
        setupCompletionContainer()
        
        // Ajouter les boutons de navigation
        view.addSubview(buttonsStackView)
        view.addSubview(activityIndicator)
    }
    
    private func setupStepIndicator() {
        let stepTitles = ["Info", "Contact", "Schedule", "Password", "Done"]
        for (index, title) in stepTitles.enumerated() {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 12, weight: index <= 0 ? .bold : .regular)
            label.textAlignment = .center
            label.textColor = index == 0 ? .systemBlue : .secondaryLabel
            label.tag = index
            stepLabelsStack.addArrangedSubview(label)
        }
    }
    
    private func setupOrganizationInfoContainer() {
        contentView.addSubview(organizationInfoContainer)
        
        organizationInfoContainer.addSubview(organizationNameTextField)
        organizationInfoContainer.addSubview(organizationTypeLabel)
        organizationInfoContainer.addSubview(organizationTypeSegment)
        organizationInfoContainer.addSubview(descriptionLabel)
        organizationInfoContainer.addSubview(descriptionTextView)
        organizationInfoContainer.addSubview(descriptionPlaceholder)
        organizationInfoContainer.addSubview(contactPersonTextField)
        
        descriptionTextView.delegate = self
    }
    
    private func setupContactInfoContainer() {
        contentView.addSubview(contactInfoContainer)
        
        contactInfoContainer.addSubview(emailTextField)
        contactInfoContainer.addSubview(phoneTextField)
        contactInfoContainer.addSubview(buildingNumberTextField)
        contactInfoContainer.addSubview(poBoxTextField)
        contactInfoContainer.addSubview(registrationNumberTextField)
        contactInfoContainer.addSubview(uploadDocumentLabel)
        contactInfoContainer.addSubview(uploadDocumentButton)
        contactInfoContainer.addSubview(termsSwitch)
        contactInfoContainer.addSubview(termsLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        termsLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupPickupScheduleContainer() {
        contentView.addSubview(pickupScheduleContainer)
        
        pickupScheduleContainer.addSubview(pickupFrequencyLabel)
        pickupScheduleContainer.addSubview(pickupFrequencySegment)
        pickupScheduleContainer.addSubview(pickupDaysLabel)
        pickupScheduleContainer.addSubview(pickupDaysStackView)
        
        // Créer les boutons pour chaque jour
        for day in WeekDay.collectionDays {
            let button = createDayButton(for: day)
            dayButtons.append(button)
            pickupDaysStackView.addArrangedSubview(button)
        }
    }
    
    private func createDayButton(for day: WeekDay) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(day.shortName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 8
        button.tag = WeekDay.collectionDays.firstIndex(of: day) ?? 0
        button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupPasswordContainer() {
        contentView.addSubview(passwordContainer)
        
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(confirmPasswordTextField)
    }
    
    private func setupCompletionContainer() {
        contentView.addSubview(completionContainer)
        
        completionContainer.addSubview(successImageView)
        completionContainer.addSubview(successTitleLabel)
        completionContainer.addSubview(successMessageLabel)
        completionContainer.addSubview(goToDashboardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Navigation Bar
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Step Indicator
            stepIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stepIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stepIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            
            stepLabelsStack.topAnchor.constraint(equalTo: stepIndicatorView.topAnchor),
            stepLabelsStack.leadingAnchor.constraint(equalTo: stepIndicatorView.leadingAnchor),
            stepLabelsStack.trailingAnchor.constraint(equalTo: stepIndicatorView.trailingAnchor),
            stepLabelsStack.bottomAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor),
            
            // Organisation Info Container
            organizationInfoContainer.topAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor, constant: 20),
            organizationInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            organizationInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            organizationNameTextField.topAnchor.constraint(equalTo: organizationInfoContainer.topAnchor),
            organizationNameTextField.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            organizationNameTextField.trailingAnchor.constraint(equalTo: organizationInfoContainer.trailingAnchor),
            organizationNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            organizationTypeLabel.topAnchor.constraint(equalTo: organizationNameTextField.bottomAnchor, constant: 16),
            organizationTypeLabel.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            
            organizationTypeSegment.topAnchor.constraint(equalTo: organizationTypeLabel.bottomAnchor, constant: 8),
            organizationTypeSegment.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            organizationTypeSegment.trailingAnchor.constraint(equalTo: organizationInfoContainer.trailingAnchor),
            organizationTypeSegment.heightAnchor.constraint(equalToConstant: 40),
            
            contactPersonTextField.topAnchor.constraint(equalTo: organizationTypeSegment.bottomAnchor, constant: 16),
            contactPersonTextField.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            contactPersonTextField.trailingAnchor.constraint(equalTo: organizationInfoContainer.trailingAnchor),
            contactPersonTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: contactPersonTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: organizationInfoContainer.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: organizationInfoContainer.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionPlaceholder.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholder.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            
            organizationInfoContainer.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            
            // Contact Info Container
            contactInfoContainer.topAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor, constant: 20),
            contactInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contactInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: contactInfoContainer.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            buildingNumberTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            buildingNumberTextField.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            buildingNumberTextField.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            buildingNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            poBoxTextField.topAnchor.constraint(equalTo: buildingNumberTextField.bottomAnchor, constant: 12),
            poBoxTextField.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            poBoxTextField.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            poBoxTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registrationNumberTextField.topAnchor.constraint(equalTo: poBoxTextField.bottomAnchor, constant: 12),
            registrationNumberTextField.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            registrationNumberTextField.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            registrationNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            
            uploadDocumentLabel.topAnchor.constraint(equalTo: registrationNumberTextField.bottomAnchor, constant: 20),
            uploadDocumentLabel.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            
            uploadDocumentButton.topAnchor.constraint(equalTo: uploadDocumentLabel.bottomAnchor, constant: 8),
            uploadDocumentButton.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            uploadDocumentButton.trailingAnchor.constraint(equalTo: contactInfoContainer.trailingAnchor),
            uploadDocumentButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsSwitch.topAnchor.constraint(equalTo: uploadDocumentButton.bottomAnchor, constant: 20),
            termsSwitch.leadingAnchor.constraint(equalTo: contactInfoContainer.leadingAnchor),
            
            termsLabel.centerYAnchor.constraint(equalTo: termsSwitch.centerYAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: termsSwitch.trailingAnchor, constant: 10),
            
            contactInfoContainer.bottomAnchor.constraint(equalTo: termsSwitch.bottomAnchor),
            
            // Pickup Schedule Container
            pickupScheduleContainer.topAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor, constant: 20),
            pickupScheduleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pickupScheduleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            pickupFrequencyLabel.topAnchor.constraint(equalTo: pickupScheduleContainer.topAnchor),
            pickupFrequencyLabel.leadingAnchor.constraint(equalTo: pickupScheduleContainer.leadingAnchor),
            
            pickupFrequencySegment.topAnchor.constraint(equalTo: pickupFrequencyLabel.bottomAnchor, constant: 8),
            pickupFrequencySegment.leadingAnchor.constraint(equalTo: pickupScheduleContainer.leadingAnchor),
            pickupFrequencySegment.trailingAnchor.constraint(equalTo: pickupScheduleContainer.trailingAnchor),
            pickupFrequencySegment.heightAnchor.constraint(equalToConstant: 40),
            
            pickupDaysLabel.topAnchor.constraint(equalTo: pickupFrequencySegment.bottomAnchor, constant: 24),
            pickupDaysLabel.leadingAnchor.constraint(equalTo: pickupScheduleContainer.leadingAnchor),
            
            pickupDaysStackView.topAnchor.constraint(equalTo: pickupDaysLabel.bottomAnchor, constant: 12),
            pickupDaysStackView.leadingAnchor.constraint(equalTo: pickupScheduleContainer.leadingAnchor),
            pickupDaysStackView.trailingAnchor.constraint(equalTo: pickupScheduleContainer.trailingAnchor),
            pickupDaysStackView.heightAnchor.constraint(equalToConstant: 50),
            
            pickupScheduleContainer.bottomAnchor.constraint(equalTo: pickupDaysStackView.bottomAnchor),
            
            // Password Container
            passwordContainer.topAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor, constant: 20),
            passwordContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordContainer.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordContainer.bottomAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor),
            
            // Completion Container
            completionContainer.topAnchor.constraint(equalTo: stepIndicatorView.bottomAnchor, constant: 40),
            completionContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            completionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            successImageView.topAnchor.constraint(equalTo: completionContainer.topAnchor),
            successImageView.centerXAnchor.constraint(equalTo: completionContainer.centerXAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 100),
            successImageView.heightAnchor.constraint(equalToConstant: 100),
            
            successTitleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 24),
            successTitleLabel.leadingAnchor.constraint(equalTo: completionContainer.leadingAnchor),
            successTitleLabel.trailingAnchor.constraint(equalTo: completionContainer.trailingAnchor),
            
            successMessageLabel.topAnchor.constraint(equalTo: successTitleLabel.bottomAnchor, constant: 12),
            successMessageLabel.leadingAnchor.constraint(equalTo: completionContainer.leadingAnchor),
            successMessageLabel.trailingAnchor.constraint(equalTo: completionContainer.trailingAnchor),
            
            goToDashboardButton.topAnchor.constraint(equalTo: successMessageLabel.bottomAnchor, constant: 32),
            goToDashboardButton.leadingAnchor.constraint(equalTo: completionContainer.leadingAnchor),
            goToDashboardButton.trailingAnchor.constraint(equalTo: completionContainer.trailingAnchor),
            goToDashboardButton.heightAnchor.constraint(equalToConstant: 50),
            
            completionContainer.bottomAnchor.constraint(equalTo: goToDashboardButton.bottomAnchor),
            
            // Navigation Buttons
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
        ])
    }
    
    // MARK: - Gestion du clavier
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc private func organizationTypeChanged() {
        selectedOrganizationType = OrganizationType.allCases[organizationTypeSegment.selectedSegmentIndex]
    }
    
    @objc private func pickupFrequencyChanged() {
        selectedPickupFrequency = PickupFrequency.allCases[pickupFrequencySegment.selectedSegmentIndex]
        updateDayButtons()
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        let day = WeekDay.collectionDays[sender.tag]
        
        if selectedPickupDays.contains(day) {
            selectedPickupDays.remove(day)
            sender.backgroundColor = .secondarySystemBackground
            sender.setTitleColor(.systemBlue, for: .normal)
        } else {
            selectedPickupDays.insert(day)
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    private func updateDayButtons() {
        for (index, button) in dayButtons.enumerated() {
            let day = WeekDay.collectionDays[index]
            if selectedPickupDays.contains(day) {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .secondarySystemBackground
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
    
    @objc private func uploadDocumentTapped() {
        // Implémenter la sélection de document
        showAlert(title: "Upload Document", message: "Cette fonctionnalité sera implémentée pour sélectionner un document de vérification.")
    }
    
    @objc private func termsSwitchChanged() {
        registrationData.agreedToTerms = termsSwitch.isOn
    }
    
    @objc private func termsLabelTapped() {
        showTermsAndConditions()
    }
    
    @objc private func backButtonTapped() {
        navigateToPreviousStep()
    }
    
    @objc private func nextButtonTapped() {
        guard validateCurrentStep() else { return }
        navigateToNextStep()
    }
    
    @objc private func goToDashboardTapped() {
        // Naviguer vers le tableau de bord
        if let dashboardVC = storyboard?.instantiateViewController(withIdentifier: "CollectorDashboardController") {
            navigationController?.setViewControllers([dashboardVC], animated: true)
        }
    }
    
    // MARK: - Navigation entre les étapes
    
    private func updateUIForCurrentStep() {
        // Masquer tous les conteneurs
        organizationInfoContainer.isHidden = currentStep != .organizationInfo
        contactInfoContainer.isHidden = currentStep != .contactInfo
        pickupScheduleContainer.isHidden = currentStep != .pickupSchedule
        passwordContainer.isHidden = currentStep != .password
        completionContainer.isHidden = currentStep != .completion
        
        // Mettre à jour l'indicateur d'étapes
        updateStepIndicator()
        
        // Mettre à jour les boutons
        updateNavigationButtons()
    }
    
    private func updateStepIndicator() {
        let stepIndex = stepIndexForCurrentStep()
        
        for case let (index, label as UILabel) in stepLabelsStack.arrangedSubviews.enumerated() {
            label.font = UIFont.systemFont(ofSize: 12, weight: index == stepIndex ? .bold : index < stepIndex ? .semibold : .regular)
            label.textColor = index <= stepIndex ? .systemBlue : .secondaryLabel
        }
    }
    
    private func updateNavigationButtons() {
        backButton.isHidden = currentStep == .organizationInfo || currentStep == .completion
        
        switch currentStep {
        case .organizationInfo:
            nextButton.setTitle("Next", for: .normal)
        case .contactInfo:
            nextButton.setTitle("Next", for: .normal)
        case .pickupSchedule:
            nextButton.setTitle("Next", for: .normal)
        case .password:
            nextButton.setTitle("Register", for: .normal)
        case .completion:
            nextButton.isHidden = true
        }
    }
    
    private func stepIndexForCurrentStep() -> Int {
        switch currentStep {
        case .organizationInfo: return 0
        case .contactInfo: return 1
        case .pickupSchedule: return 2
        case .password: return 3
        case .completion: return 4
        }
    }
    
    private func navigateToNextStep() {
        saveCurrentStepData()
        
        switch currentStep {
        case .organizationInfo:
            currentStep = .contactInfo
        case .contactInfo:
            currentStep = .pickupSchedule
        case .pickupSchedule:
            currentStep = .password
        case .password:
            completeRegistration()
            return
        case .completion:
            return
        }
        
        updateUIForCurrentStep()
    }
    
    private func navigateToPreviousStep() {
        switch currentStep {
        case .organizationInfo:
            break
        case .contactInfo:
            currentStep = .organizationInfo
        case .pickupSchedule:
            currentStep = .contactInfo
        case .password:
            currentStep = .pickupSchedule
        case .completion:
            break
        }
        
        updateUIForCurrentStep()
    }
    
    // MARK: - Validation
    
    private func validateCurrentStep() -> Bool {
        switch currentStep {
        case .organizationInfo:
            return validateOrganizationInfo()
        case .contactInfo:
            return validateContactInfo()
        case .pickupSchedule:
            return validatePickupSchedule()
        case .password:
            return validatePassword()
        case .completion:
            return true
        }
    }
    
    private func validateOrganizationInfo() -> Bool {
        var errors: [String] = []
        
        if organizationNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Le nom de l'organisation est requis")
        }
        
        if contactPersonTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Le nom du contact est requis")
        }
        
        if descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("La description est requise")
        }
        
        if !errors.isEmpty {
            showValidationError(errors.joined(separator: "\n"))
            return false
        }
        
        return true
    }
    
    private func validateContactInfo() -> Bool {
        var errors: [String] = []
        
        if let email = emailTextField.text, !isValidEmail(email) {
            errors.append("Veuillez entrer une adresse email valide")
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("L'email est requis")
        }
        
        if phoneTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Le numéro de téléphone est requis")
        }
        
        if buildingNumberTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Le numéro de bâtiment est requis")
        }
        
        if poBoxTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("La boîte postale est requise")
        }
        
        if registrationNumberTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            errors.append("Le numéro d'enregistrement est requis")
        }
        
        if !termsSwitch.isOn {
            errors.append("Vous devez accepter les conditions générales")
        }
        
        if !errors.isEmpty {
            showValidationError(errors.joined(separator: "\n"))
            return false
        }
        
        return true
    }
    
    private func validatePickupSchedule() -> Bool {
        if selectedPickupDays.isEmpty {
            showValidationError("Veuillez sélectionner au moins un jour de collecte")
            return false
        }
        return true
    }
    
    private func validatePassword() -> Bool {
        var errors: [String] = []
        
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        if password.count < 8 {
            errors.append("Le mot de passe doit contenir au moins 8 caractères")
        }
        
        if password != confirmPassword {
            errors.append("Les mots de passe ne correspondent pas")
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
    
    // MARK: - Sauvegarde des données
    
    private func saveCurrentStepData() {
        switch currentStep {
        case .organizationInfo:
            registrationData.organizationName = organizationNameTextField.text ?? ""
            registrationData.organizationType = selectedOrganizationType
            registrationData.contactPerson = contactPersonTextField.text ?? ""
            registrationData.description = descriptionTextView.text
            
        case .contactInfo:
            registrationData.contactEmail = emailTextField.text ?? ""
            registrationData.contactPhoneNumber = phoneTextField.text ?? ""
            registrationData.buildingNumber = buildingNumberTextField.text ?? ""
            registrationData.poBoxNumber = poBoxTextField.text ?? ""
            registrationData.registrationNumber = registrationNumberTextField.text ?? ""
            
        case .pickupSchedule:
            registrationData.pickupFrequency = selectedPickupFrequency
            registrationData.pickupDays = Array(selectedPickupDays)
            
        case .password:
            break
            
        case .completion:
            break
        }
    }
    
    // MARK: - Inscription
    
    private func completeRegistration() {
        // Afficher l'indicateur de chargement
        showLoading(true)
        
        // Simuler l'appel API
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showLoading(false)
            self?.registrationData.id = UUID().uuidString
            self?.registrationData.isVerified = false
            self?.registrationData.createdAt = Date()
            self?.registrationData.updatedAt = Date()
            
            print("Inscription Collector réussie: \(self?.registrationData.organizationName ?? "")")
            
            // Afficher l'écran de succès
            self?.currentStep = .completion
            self?.updateUIForCurrentStep()
        }
    }
    
    private func showLoading(_ loading: Bool) {
        nextButton.isEnabled = !loading
        if loading {
            nextButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            nextButton.setTitle("Register", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Alertes
    
    private func showValidationError(_ message: String) {
        let alert = UIAlertController(title: "Erreur de validation", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showTermsAndConditions() {
        let alert = UIAlertController(
            title: "Conditions générales",
            message: "En vous inscrivant en tant que collecteur, vous acceptez de:\n\n1. Fournir des informations précises sur l'organisation\n2. Utiliser les dons uniquement à des fins caritatives\n3. Respecter les normes de sécurité alimentaire appropriées\n4. Signaler tout problème rapidement\n5. Respecter la vie privée des donateurs",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "J'accepte", style: .default) { [weak self] _ in
            self?.termsSwitch.isOn = true
            self?.registrationData.agreedToTerms = true
        })
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CollectorRegistrationController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholder.isHidden = !textView.text.isEmpty
    }
}
