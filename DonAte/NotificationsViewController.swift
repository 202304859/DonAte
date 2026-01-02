import UIKit

// MARK: - Notification Model
struct AppNotification {
    let id: String
    let title: String
    let message: String
    let icon: String
    let iconBackgroundColor: UIColor
    let isRead: Bool
    let isUrgent: Bool
    let timestamp: Date
    
    static func sampleData() -> [AppNotification] {
        return [
            AppNotification(
                id: "1",
                title: "Donation Accepted!",
                message: "You've successfully accepted a donation.",
                icon: "checkmark.circle.fill",
                iconBackgroundColor: .donateGreen,
                isRead: false,
                isUrgent: false,
                timestamp: Date()
            ),
            AppNotification(
                id: "2",
                title: "New donations available!",
                message: "There are new available donation! check them out to help!",
                icon: "shippingbox.fill",
                iconBackgroundColor: .donateGreen,
                isRead: false,
                isUrgent: false,
                timestamp: Date().addingTimeInterval(-3600)
            ),
            AppNotification(
                id: "3",
                title: "Reminder: Pick up scheduled!",
                message: "Don't forget to pick up the donation today at 5:00 pm",
                icon: "car.fill",
                iconBackgroundColor: .donateGreen,
                isRead: true,
                isUrgent: true,
                timestamp: Date().addingTimeInterval(-7200)
            ),
            AppNotification(
                id: "4",
                title: "Donation complete!",
                message: "Donation has been delivered back at the facility thank you!",
                icon: "gift.fill",
                iconBackgroundColor: .donateGreen,
                isRead: true,
                isUrgent: false,
                timestamp: Date().addingTimeInterval(-86400)
            ),
            AppNotification(
                id: "5",
                title: "Account has been approved!",
                message: "Congratulations your account has been successfully verified.",
                icon: "checkmark.circle.fill",
                iconBackgroundColor: .donateGreen,
                isRead: true,
                isUrgent: false,
                timestamp: Date().addingTimeInterval(-172800)
            )
        ]
    }
}

class NotificationsViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var headerView: UIView!
    private var filterStackView: UIStackView!
    private var countLabel: UILabel!
    private var tableView: UITableView!
    
    // MARK: - Properties
    private var allNotifications: [AppNotification] = []
    private var filteredNotifications: [AppNotification] = []
    private var currentFilter = "All"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        allNotifications = AppNotification.sampleData()
        filteredNotifications = allNotifications
        createUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Create UI
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        
        // Header View
        headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "b4e7b4")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Notifications"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // Filter Buttons Container
        let filterContainer = UIView()
        filterContainer.backgroundColor = .white
        filterContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterContainer)
        
        // Filter Stack View
        filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        filterStackView.spacing = 12
        filterStackView.distribution = .fillEqually
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        filterContainer.addSubview(filterStackView)
        
        // Create filter buttons
        let filters = ["All", "Unread", "Read", "Urgent"]
        for filter in filters {
            let button = createFilterButton(title: filter)
            button.isSelected = filter == "All"
            filterStackView.addArrangedSubview(button)
        }
        
        // Notifications Count Label
        countLabel = UILabel()
        countLabel.text = "Notifications' Count (\(allNotifications.count))"
        countLabel.font = .systemFont(ofSize: 14)
        countLabel.textColor = .gray
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countLabel)
        
        // Table View
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Header View - extends from very top of screen behind status bar
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Make header extend well below safe area for a spacious look
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            // Position title with proper spacing from safe area
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            
            // Filter Container
            filterContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            filterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterContainer.heightAnchor.constraint(equalToConstant: 60),
            
            filterStackView.centerYAnchor.constraint(equalTo: filterContainer.centerYAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: filterContainer.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 36),
            
            // Count Label
            countLabel.topAnchor.constraint(equalTo: filterContainer.bottomAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.donateGreen.cgColor
        button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        updateFilterButtonAppearance(button, isSelected: title == "All")
        return button
    }
    
    private func updateFilterButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = .donateGreen
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.donateGreen, for: .normal)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    @objc private func filterTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        currentFilter = title
        
        // Update button appearances
        for case let button as UIButton in filterStackView.arrangedSubviews {
            updateFilterButtonAppearance(button, isSelected: button.titleLabel?.text == title)
        }
        
        // Filter notifications
        switch title {
        case "Unread":
            filteredNotifications = allNotifications.filter { !$0.isRead }
        case "Read":
            filteredNotifications = allNotifications.filter { $0.isRead }
        case "Urgent":
            filteredNotifications = allNotifications.filter { $0.isUrgent }
        default:
            filteredNotifications = allNotifications
        }
        
        countLabel.text = "Notifications' Count (\(filteredNotifications.count))"
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configure(with: filteredNotifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NotificationCell
class NotificationCell: UITableViewCell {
    
    private let cardView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Card View
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.donateGreen.cgColor
        contentView.addSubview(cardView)
        
        // Icon Container
        iconContainerView.backgroundColor = UIColor.donateGreen.withAlphaComponent(0.1)
        iconContainerView.layer.cornerRadius = 25
        cardView.addSubview(iconContainerView)
        
        // Icon Image View
        iconImageView.tintColor = .donateGreen
        iconImageView.contentMode = .scaleAspectFit
        iconContainerView.addSubview(iconImageView)
        
        // Title Label
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        cardView.addSubview(titleLabel)
        
        // Message Label
        messageLabel.font = .systemFont(ofSize: 13)
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 2
        cardView.addSubview(messageLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, iconContainerView, iconImageView, titleLabel, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            iconContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconContainerView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(with notification: AppNotification) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        iconImageView.image = UIImage(systemName: notification.icon)
    }
}
