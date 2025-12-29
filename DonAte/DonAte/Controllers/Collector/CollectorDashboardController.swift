//
//  CollectorDashboardController.swift
//  DonAte
//
//  Tableau de bord Collector avec toutes les fonctionnalités du PDF
//  Affichage des statistiques, actions rapides et notifications
//

import UIKit

/// Contrôleur du tableau de bord Collector
class CollectorDashboardController: UIViewController {
    
    // MARK: - Propriétés
    
    private var profile: CollectorProfile?
    private var notifications: [NotificationItem] = []
    private var unreadNotificationsCount: Int = 5
    
    // MARK: - UI Components - Navigation Personnalisée
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    // MARK: - UI Components - Scroll View
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Components - En-tête
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - UI Components - Section Actions Rapides
    
    private lazy var quickActionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Quick actions"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quickActionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - UI Components - Cartes d'actions
    
    private lazy var availableDonationCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "gift.fill",
            title: "Available\nDonation",
            iconColor: .systemGreen
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(availableDonationTapped)))
        return card
    }()
    
    private lazy var editProfileCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "person.crop.circle.fill",
            title: "Edit\nProfile",
            iconColor: .systemBlue
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileTapped)))
        return card
    }()
    
    private lazy var impactSummaryCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "chart.bar.fill",
            title: "Impact\nSummary",
            iconColor: .systemPurple
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(impactSummaryTapped)))
        return card
    }()
    
    private lazy var donationHistoryCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "clock.fill",
            title: "Donation\nHistory",
            iconColor: .systemOrange
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(donationHistoryTapped)))
        return card
    }()
    
    private lazy var changeScheduleCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "calendar.badge.clock",
            title: "Change\nSchedule",
            iconColor: .systemTeal
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeScheduleTapped)))
        return card
    }()
    
    private lazy var changePasswordCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "lock.fill",
            title: "Change\nPassword",
            iconColor: .systemRed
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped)))
        return card
    }()
    
    private lazy var messagesCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "message.fill",
            title: "Messages",
            iconColor: .systemIndigo
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(messagesTapped)))
        return card
    }()
    
    private lazy var notificationsCard: ActionCardView = {
        let card = ActionCardView(
            iconName: "bell.fill",
            title: "Notifications",
            iconColor: .systemYellow
        )
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationsTapped)))
        return card
    }()
    
    private lazy var notificationBadge: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        return label
    }()
    
    // MARK: - UI Components - Section Pickups Récents
    
    private lazy var pickupsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Pickups"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pickupsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadProfileData()
        loadNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Configuration de l'interface utilisateur
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Ajouter la barre de navigation personnalisée
        view.addSubview(customNavBar)
        
        // Configurer la barre de navigation
        customNavBar.configure(style: .logoWithTitle, rightButtonAction: nil)
        
        // Ajouter le scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Configurer l'en-tête
        setupHeaderView()
        
        // Configurer les actions rapides
        setupQuickActions()
        
        // Configurer la section pickups
        setupPickupsSection()
    }
    
    private func setupHeaderView() {
        contentView.addSubview(headerView)
        headerView.addSubview(organizationNameLabel)
        headerView.addSubview(welcomeLabel)
    }
    
    private func setupQuickActions() {
        contentView.addSubview(quickActionsLabel)
        
        // Première rangée
        let firstRowStack = UIStackView(arrangedSubviews: [availableDonationCard, editProfileCard])
        firstRowStack.axis = .horizontal
        firstRowStack.spacing = 12
        firstRowStack.distribution = .fillEqually
        
        // Deuxième rangée
        let secondRowStack = UIStackView(arrangedSubviews: [impactSummaryCard, donationHistoryCard])
        secondRowStack.axis = .horizontal
        secondRowStack.spacing = 12
        secondRowStack.distribution = .fillEqually
        
        // Troisième rangée
        let thirdRowStack = UIStackView(arrangedSubviews: [changeScheduleCard, changePasswordCard])
        thirdRowStack.axis = .horizontal
        thirdRowStack.spacing = 12
        thirdRowStack.distribution = .fillEqually
        
        // Quatrième rangée
        let fourthRowStack = UIStackView(arrangedSubviews: [messagesCard, notificationsCard])
        fourthRowStack.axis = .horizontal
        fourthRowStack.spacing = 12
        fourthRowStack.distribution = .fillEqually
        
        quickActionsStackView.addArrangedSubview(firstRowStack)
        quickActionsStackView.addArrangedSubview(secondRowStack)
        quickActionsStackView.addArrangedSubview(thirdRowStack)
        quickActionsStackView.addArrangedSubview(fourthRowStack)
        
        contentView.addSubview(quickActionsStackView)
        
        // Ajouter le badge de notification
        notificationsCard.addSubview(notificationBadge)
    }
    
    private func setupPickupsSection() {
        contentView.addSubview(pickupsSectionLabel)
        contentView.addSubview(pickupsStackView)
        
        // Ajouter des pickups示例
        addPickupItem(date: "February 12, 2022", pickupNumber: "#78", itemsCount: "5 items", status: "On the way", statusColor: .systemBlue)
        addPickupItem(date: "February 1, 2022", pickupNumber: "#23", itemsCount: "5 items", status: "Accepted", statusColor: .systemGreen)
    }
    
    private func addPickupItem(date: String, pickupNumber: String, itemsCount: String, status: String, statusColor: UIColor) {
        let pickupView = PickupItemView()
        pickupView.configure(date: date, pickupNumber: pickupNumber, itemsCount: itemsCount, status: status, statusColor: statusColor)
        pickupsStackView.addArrangedSubview(pickupView)
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
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header View
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 70),
            
            organizationNameLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            organizationNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            organizationNameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: organizationNameLabel.bottomAnchor, constant: 4),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            // Quick Actions Label
            quickActionsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            quickActionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // Quick Actions Stack View
            quickActionsStackView.topAnchor.constraint(equalTo: quickActionsLabel.bottomAnchor, constant: 16),
            quickActionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quickActionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Notification Badge
            notificationBadge.topAnchor.constraint(equalTo: notificationsCard.topAnchor, constant: -5),
            notificationBadge.trailingAnchor.constraint(equalTo: notificationsCard.trailingAnchor, constant: 5),
            notificationBadge.widthAnchor.constraint(equalToConstant: 20),
            notificationBadge.heightAnchor.constraint(equalToConstant: 20),
            
            // Pickups Section
            pickupsSectionLabel.topAnchor.constraint(equalTo: quickActionsStackView.bottomAnchor, constant: 30),
            pickupsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            pickupsStackView.topAnchor.constraint(equalTo: pickupsSectionLabel.bottomAnchor, constant: 16),
            pickupsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pickupsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pickupsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - Chargement des données
    
    private func loadProfileData() {
        // Charger les données du profil (simulées)
        organizationNameLabel.text = "Kaaf Humanitarian NGO"
    }
    
    private func loadNotifications() {
        // Simuler les notifications
        notificationBadge.text = "\(unreadNotificationsCount)"
    }
    
    // MARK: - Actions
    
    @objc private func availableDonationTapped() {
        showAlert(title: "Available Donations", message: "Affichage des donations disponibles pour collecte.")
    }
    
    @objc private func editProfileTapped() {
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "CollectorProfileController") {
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc private func impactSummaryTapped() {
        showAlert(title: "Impact Summary", message: "Total: 50kg collectés • 25 donations • Impact score: 85")
    }
    
    @objc private func donationHistoryTapped() {
        showAlert(title: "Donation History", message: "Affichage de l'historique des donations.")
    }
    
    @objc private func changeScheduleTapped() {
        showAlert(title: "Change Schedule", message: "Modifier les horaires de collecte.")
    }
    
    @objc private func changePasswordTapped() {
        showAlert(title: "Change Password", message: "Fonctionnalité de changement de mot de passe.")
    }
    
    @objc private func messagesTapped() {
        showAlert(title: "Messages", message: "Affichage des messages.")
    }
    
    @objc private func notificationsTapped() {
        // Naviguer vers l'écran des notifications
        let notificationsVC = CollectorNotificationsController()
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Modèle de notification

struct NotificationItem {
    let id: String
    let title: String
    let message: String
    let date: Date
    let type: NotificationType
    var isRead: Bool
    
    enum NotificationType {
        case donationAccepted
        case newDonation
        case reminder
        case donationComplete
        case accountApproved
    }
}

// MARK: - Contrôleur de notifications Collector

class CollectorNotificationsController: UIViewController {
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private lazy var notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    private let sampleNotifications: [(String, String, UIColor)] = [
        ("Donation Accepted!", "You've successfully accepted a donation", .systemGreen),
        ("New donations available!", "There are new available donation! check them out to help!", .systemBlue),
        ("Reminder: Pickup scheduled!", "Don't forget to pickup the donation today at 5:00pm", .systemOrange),
        ("Donation complete!", "Donation has been delivered back at the facility thank you!", .systemPurple),
        ("Account has been approved!", "Congratulations your account has been successfully verified.", .systemTeal)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(customNavBar)
        customNavBar.configure(style: .backWithTitle(title: "Notifications"), rightButtonAction: nil)
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(notificationsTableView)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            notificationsTableView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension CollectorNotificationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = sampleNotifications[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = notification.0
        content.secondaryText = notification.1
        content.textProperties.color = notification.2
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.numberOfLines = 2
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Vue de carte d'action personnalisée

class ActionCardView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(iconName: String, title: String, iconColor: UIColor) {
        super.init(frame: .zero)
        setupView()
        configure(iconName: iconName, title: title, iconColor: iconColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(iconName: String, title: String, iconColor: UIColor) {
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = iconColor
        titleLabel.text = title
    }
}

// MARK: - Vue d'élément de pickup

class PickupItemView: UIView {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pickupNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        
        addSubview(dateLabel)
        addSubview(pickupNumberLabel)
        addSubview(itemsCountLabel)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            statusLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            pickupNumberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            pickupNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            itemsCountLabel.centerYAnchor.constraint(equalTo: pickupNumberLabel.centerYAnchor),
            itemsCountLabel.leadingAnchor.constraint(equalTo: pickupNumberLabel.trailingAnchor, constant: 8),
            
            heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func configure(date: String, pickupNumber: String, itemsCount: String, status: String, statusColor: UIColor) {
        dateLabel.text = date
        pickupNumberLabel.text = pickupNumber
        itemsCountLabel.text = itemsCount
        statusLabel.text = "  \(status)  "
        statusLabel.textColor = statusColor
        statusLabel.backgroundColor = statusColor.withAlphaComponent(0.2)
    }
    @objc private func editProfileTapped() {
            // Navigate to profile screen using the CollectorProfileController directly
            let profileVC = CollectorProfileController()
            navigationController?.pushViewController(profileVC, animated: true)
        }
    
}
