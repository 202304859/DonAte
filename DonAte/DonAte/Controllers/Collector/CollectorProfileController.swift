import UIKit

/// Contrôleur pour la gestion du profil du collecteur
/// Affiche les informations de l'organisation et permet leur modification
class CollectorProfileController: UIViewController {
    
    // MARK: - Properties
    
    /// Profil du collecteur - données principales
    private var profile: CollectorProfile
    
    /// Mode édition actif ou non
    private var isEditingMode = false
    
    /// Données statistiques (mock pour démonstration)
    private var stats: CollectorStats = CollectorStats(
        totalDonations: 156,
        totalRaised: 1250,
        impactScore: 89
    )
    
    // MARK: - UI Components
    
    /// Barre de navigation personnalisée
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    /// Vue de défilement principale
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    /// Vue conteneur du contenu
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Header Section Components
    
    /// Image de profil de l'organisation
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "building.2.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// Nom de l'organisation
    private lazy var orgNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    /// Badge de vérification
    private lazy var verifiedBadgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 12
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark.seal.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Verified"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        return view
    }()
    
    /// Type d'organisation
    private lazy var orgTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Statistics Section Components
    
    /// Container des statistiques
    private lazy var statsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    /// Label du nombre de dons
    private lazy var donationsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    /// Label du titre "Donations"
    private lazy var donationsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Donations"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Label du montant collecté
    private lazy var raisedAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    
    /// Label du titre "Raised"
    private lazy var raisedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Raised (kg)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Label du score d'impact
    private lazy var impactScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemPurple
        return label
    }()
    
    /// Label du titre "Impact"
    private lazy var impactTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Impact"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Information Section Components
    
    /// Container des informations
    private lazy var infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    /// Titre de la section informations
    private lazy var infoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Organization Information"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    /// Label "Email"
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur de l'email (mode affichage)
    private lazy var emailValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    /// Label "Phone"
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phone"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur du téléphone (mode affichage)
    private lazy var phoneValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    /// Champ de saisie du téléphone (mode édition)
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .phonePad
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        return textField
    }()
    
    /// Label "Address"
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Address"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur de l'adresse (mode affichage)
    private lazy var addressValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    /// Champ de saisie de l'adresse (mode édition)
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        return textField
    }()
    
    /// Label "Website"
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Website"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur du site web (mode affichage)
    private lazy var websiteValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    /// Champ de saisie du site web (mode édition)
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        return textField
    }()
    
    /// Label "Description"
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur de la description (mode affichage)
    private lazy var descriptionValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    /// Zone de texte de la description (mode édition)
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    /// Séparateur entre les sections
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    /// Label "Registration Number"
    private lazy var regNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Registration Number"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur du numéro d'enregistrement (mode affichage)
    private lazy var regNumberValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    /// Label "Contact Person"
    private lazy var contactPersonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contact Person"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    /// Valeur de la personne de contact (mode affichage)
    private lazy var contactPersonValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    /// Champ de saisie de la personne de contact (mode édition)
    private lazy var contactPersonTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        return textField
    }()
    
    // MARK: - Initialization
    
    init(profile: CollectorProfile = CollectorProfile(
        id: "col_001",
        orgName: "Green Earth Foundation",
        orgType: .charity,
        description: "We are dedicated to collecting surplus food and distributing it to those in need. Our mission is to reduce food waste while fighting hunger in our community.",
        contactPerson: "John Smith",
        regNumber: "REG-2024-001234",
        email: "contact@greenearth.org",
        phone: "+1 234 567 8900",
        address: "456 Environment Avenue, Green City, GC 54321",
        website: "https://greenearth.org",
        pickupFrequency: .weekly,
        pickupDays: [.monday, .wednesday, .friday],
        preferredPickupTime: "09:00 - 17:00",
        isVerified: true
    )) {
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
        loadProfileData()
        setupKeyboardDismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Ajouter les composants à la vue
        view.addSubview(customNavBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Configurer les sections
        setupHeaderSection()
        setupStatsSection()
        setupInfoSection()
        
        // Configurer les contraintes
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        customNavBar.configure(
            style: .backWithTitle(title: "My Profile"),
            rightButtonTitle: "Edit",
            rightButtonAction: { [weak self] in
                self?.toggleEditMode()
            }
        )
        
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupHeaderSection() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(orgNameLabel)
        contentView.addSubview(verifiedBadgeView)
        contentView.addSubview(orgTypeLabel)
    }
    
    private func setupStatsSection() {
        contentView.addSubview(statsContainerView)
        
        // Créer les cartes de statistiques
        let stat1 = createStatCard(valueLabel: donationsCountLabel, titleLabel: donationsTitleLabel)
        let stat2 = createStatCard(valueLabel: raisedAmountLabel, titleLabel: raisedTitleLabel)
        let stat3 = createStatCard(valueLabel: impactScoreLabel, titleLabel: impactTitleLabel)
        
        statsContainerView.addSubview(stat1)
        statsContainerView.addSubview(stat2)
        statsContainerView.addSubview(stat3)
        
        NSLayoutConstraint.activate([
            stat1.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor, constant: 10),
            stat1.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            stat1.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 0.3, constant: -13),
            
            stat2.centerXAnchor.constraint(equalTo: statsContainerView.centerXAnchor),
            stat2.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            stat2.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 0.3, constant: -13),
            
            stat3.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor, constant: -10),
            stat3.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            stat3.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 0.3, constant: -13)
        ])
    }
    
    private func setupInfoSection() {
        contentView.addSubview(infoContainerView)
        
        infoContainerView.addSubview(infoTitleLabel)
        infoContainerView.addSubview(emailLabel)
        infoContainerView.addSubview(emailValueLabel)
        infoContainerView.addSubview(contactPersonLabel)
        infoContainerView.addSubview(contactPersonValueLabel)
        infoContainerView.addSubview(contactPersonTextField)
        infoContainerView.addSubview(regNumberLabel)
        infoContainerView.addSubview(regNumberValueLabel)
        infoContainerView.addSubview(phoneLabel)
        infoContainerView.addSubview(phoneValueLabel)
        infoContainerView.addSubview(phoneTextField)
        infoContainerView.addSubview(addressLabel)
        infoContainerView.addSubview(addressValueLabel)
        infoContainerView.addSubview(addressTextField)
        infoContainerView.addSubview(websiteLabel)
        infoContainerView.addSubview(websiteValueLabel)
        infoContainerView.addSubview(websiteTextField)
        infoContainerView.addSubview(descriptionLabel)
        infoContainerView.addSubview(descriptionValueLabel)
        infoContainerView.addSubview(descriptionTextView)
        
        // Cacher les champs d'édition par défaut
        phoneTextField.isHidden = true
        addressTextField.isHidden = true
        websiteTextField.isHidden = true
        descriptionTextView.isHidden = true
        contactPersonTextField.isHidden = true
    }
    
    private func setupConstraints() {
        let contentHeight = contentView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        contentHeight.priority = .defaultLow
        contentHeight.isActive = true
        
        NSLayoutConstraint.activate([
            // Navigation Bar
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Header Section
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            orgNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            orgNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            orgNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            orgNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            verifiedBadgeView.topAnchor.constraint(equalTo: orgNameLabel.bottomAnchor, constant: 8),
            verifiedBadgeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verifiedBadgeView.heightAnchor.constraint(equalToConstant: 24),
            
            orgTypeLabel.topAnchor.constraint(equalTo: verifiedBadgeView.bottomAnchor, constant: 8),
            orgTypeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Stats Section
            statsContainerView.topAnchor.constraint(equalTo: orgTypeLabel.bottomAnchor, constant: 24),
            statsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsContainerView.heightAnchor.constraint(equalToConstant: 110),
            
            // Info Section
            infoContainerView.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 20),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            infoTitleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 16),
            infoTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            // Email
            emailLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            emailValueLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            emailValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            emailValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            // Contact Person
            contactPersonLabel.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 16),
            contactPersonLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            contactPersonValueLabel.topAnchor.constraint(equalTo: contactPersonLabel.bottomAnchor, constant: 4),
            contactPersonValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            contactPersonValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            contactPersonTextField.topAnchor.constraint(equalTo: contactPersonLabel.bottomAnchor, constant: 4),
            contactPersonTextField.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            contactPersonTextField.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            contactPersonTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Registration Number
            regNumberLabel.topAnchor.constraint(equalTo: contactPersonValueLabel.bottomAnchor, constant: 16),
            regNumberLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            regNumberValueLabel.topAnchor.constraint(equalTo: regNumberLabel.bottomAnchor, constant: 4),
            regNumberValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            regNumberValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            // Phone
            phoneLabel.topAnchor.constraint(equalTo: regNumberValueLabel.bottomAnchor, constant: 16),
            phoneLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            phoneValueLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4),
            phoneValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            phoneValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4),
            phoneTextField.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Address
            addressLabel.topAnchor.constraint(equalTo: phoneValueLabel.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            addressValueLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4),
            addressValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            addressValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4),
            addressTextField.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            addressTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Website
            websiteLabel.topAnchor.constraint(equalTo: addressValueLabel.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            websiteValueLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 4),
            websiteValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            websiteValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 4),
            websiteTextField.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: websiteValueLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            descriptionValueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            descriptionValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            descriptionValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            descriptionValueLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            descriptionTextView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            descriptionTextView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createStatCard(valueLabel: UILabel, titleLabel: UILabel) -> UIView {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(valueLabel)
        cardView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            valueLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
        
        return cardView
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Data Loading
    
    private func loadProfileData() {
        // Charger les données du profil
        orgNameLabel.text = profile.orgName
        emailValueLabel.text = profile.email
        phoneValueLabel.text = profile.phone
        addressValueLabel.text = profile.address
        websiteValueLabel.text = profile.website
        descriptionValueLabel.text = profile.description
        orgTypeLabel.text = profile.orgType.displayName
        regNumberValueLabel.text = profile.regNumber
        contactPersonValueLabel.text = profile.contactPerson
        
        // Configurer le badge de vérification
        verifiedBadgeView.isHidden = !profile.isVerified
        
        // Charger les statistiques
        donationsCountLabel.text = "\(stats.totalDonations)"
        raisedAmountLabel.text = "\(stats.totalRaised)"
        impactScoreLabel.text = "\(stats.impactScore)"
        
        // Initialiser les champs d'édition
        phoneTextField.text = profile.phone
        addressTextField.text = profile.address
        websiteTextField.text = profile.website
        descriptionTextView.text = profile.description
        contactPersonTextField.text = profile.contactPerson
    }
    
    // MARK: - Edit Mode
    
    private func toggleEditMode() {
        isEditingMode.toggle()
        
        if isEditingMode {
            // Passer en mode édition
            customNavBar.updateRightButton(title: "Save")
            
            // Afficher les champs d'édition, cacher les labels
            phoneValueLabel.isHidden = true
            addressValueLabel.isHidden = true
            websiteValueLabel.isHidden = true
            descriptionValueLabel.isHidden = true
            contactPersonValueLabel.isHidden = true
            
            phoneTextField.isHidden = false
            addressTextField.isHidden = false
            websiteTextField.isHidden = false
            descriptionTextView.isHidden = false
            contactPersonTextField.isHidden = false
            
            // Focus sur le premier champ
            contactPersonTextField.becomeFirstResponder()
        } else {
            // Sauvegarder et passer en mode affichage
            saveProfileChanges()
            
            // Passer en mode affichage
            customNavBar.updateRightButton(title: "Edit")
            
            // Mettre à jour les labels
            phoneValueLabel.text = phoneTextField.text
            addressValueLabel.text = addressTextField.text
            websiteValueLabel.text = websiteTextField.text
            descriptionValueLabel.text = descriptionTextView.text
            contactPersonValueLabel.text = contactPersonTextField.text
            
            // Cacher les champs d'édition, afficher les labels
            phoneValueLabel.isHidden = false
            addressValueLabel.isHidden = false
            websiteValueLabel.isHidden = false
            descriptionValueLabel.isHidden = false
            contactPersonValueLabel.isHidden = false
            
            phoneTextField.isHidden = true
            addressTextField.isHidden = true
            websiteTextField.isHidden = true
            descriptionTextView.isHidden = true
            contactPersonTextField.isHidden = true
            
            // Fermer le clavier
            dismissKeyboard()
            
            // Afficher un message de confirmation
            showSaveConfirmation()
        }
    }
    
    private func saveProfileChanges() {
        // Mettre à jour les données du profil
        profile.phone = phoneTextField.text ?? ""
        profile.address = addressTextField.text ?? ""
        profile.website = websiteTextField.text ?? ""
        profile.description = descriptionTextView.text ?? ""
        profile.contactPerson = contactPersonTextField.text ?? ""
        
        // TODO: Implémenter la sauvegarde vers le serveur/backend
        print("Profil sauvegardé: \(profile)")
        
        // Ici, vous pouvez ajouter l'appel API pour sauvegarder les modifications
        // Example:
        // CollectorService.shared.updateProfile(profile) { result in
        //     switch result {
        //     case .success:
        //         print("Profil mis à jour avec succès")
        //     case .failure(let error):
        //         print("Erreur de mise à jour: \(error)")
        //     }
        // }
    }
    
    private func showSaveConfirmation() {
        let alert = UIAlertController(
            title: "Success",
            message: "Profile saved successfully!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Délai pour laisser l'UI se mettre à jour
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - CollectorStats

/// Structure pour les statistiques du collecteur
struct CollectorStats {
    let totalDonations: Int
    let totalRaised: Double
    let impactScore: Int
}


