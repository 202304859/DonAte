import UIKit

class CollectorDashboardController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome Back!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let organizationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Food Bank Organization"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "pencil.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // Statistics Section
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Statistics"
        label.textColor = UIColor(hex: "#1A1A2E")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fillEqually
        return sv
    }()
    
    // Menu Section
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Quick Actions"
        label.textColor = UIColor(hex: "#1A1A2E")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let menuStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadOrganizationData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView, statsLabel, statsStackView, menuLabel, menuStackView].forEach {
            contentView.addSubview($0)
        }
        
        // Header setup
        [welcomeLabel, organizationLabel, editProfileButton].forEach {
            headerView.addSubview($0)
        }
        
        // Stats setup
        let statsData = [
            ("Total Collected", "1,234", "bag.fill"),
            ("Active Donors", "56", "person.2.fill"),
            ("Pending Pickups", "8", "clock.fill")
        ]
        
        for (title, value, icon) in statsData {
            let card = createStatCard(title: title, value: value, icon: icon)
            statsStackView.addArrangedSubview(card)
        }
        
        // Menu setup
        let menuItems = [
            ("Schedule Pickup", "calendar.badge.plus", UIColor(hex: "#4ECDC4")),
            ("View Donations", "list.bullet.rectangle", UIColor(hex: "#45B7D1")),
            ("My Profile", "person.crop.circle", UIColor(hex: "#96CEB4")),
            ("Settings", "gearshape", UIColor(hex: "#FFEAA7"))
        ]
        
        for (title, iconName, color) in menuItems {
            let card = createMenuCard(title: title, iconName: iconName, color: color)
            menuStackView.addArrangedSubview(card)
        }
        
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
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            welcomeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            organizationLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            organizationLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            editProfileButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            editProfileButton.widthAnchor.constraint(equalToConstant: 44),
            editProfileButton.heightAnchor.constraint(equalToConstant: 44),
            
            statsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            statsStackView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 16),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            menuLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            menuStackView.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 16),
            menuStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            menuStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            menuStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 600)
        ])
        
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Collector Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#FF6B6B")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func loadOrganizationData() {
        organizationLabel.text = "Food Bank Organization"
    }
    
    // MARK: - Helper Methods
    private func createStatCard(title: String, value: String, icon: String) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.1
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        iconView.image = UIImage(systemName: icon, withConfiguration: config)
        iconView.tintColor = UIColor(hex: "#FF6B6B")
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#6C757D")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: "#1A1A2E")
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            card.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return card
    }
    
    private func createMenuCard(title: String, iconName: String, color: UIColor) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.1
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconView.image = UIImage(systemName: iconName, withConfiguration: config)
        iconView.tintColor = color
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: "#1A1A2E")
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let arrowView = UIImageView()
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        arrowView.image = UIImage(systemName: "chevron.right", withConfiguration: arrowConfig)
        arrowView.tintColor = UIColor(hex: "#6C757D")
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            arrowView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            arrowView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            card.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true
        card.tag = menuStackView.arrangedSubviews.count
        
        return card
    }
    
    // MARK: - Actions
    @objc private func editProfileTapped() {
        let profileVC = CollectorProfileController()
        profileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func menuItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        
        switch index {
        case 0:
            showAlert(title: "Schedule Pickup", message: "This feature would open the pickup scheduling screen.")
        case 1:
            showAlert(title: "View Donations", message: "This feature would show all donations.")
        case 2:
            let profileVC = CollectorProfileController()
            profileVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileVC, animated: true)
        case 3:
            showAlert(title: "Settings", message: "This feature would open the settings screen.")
        default:
            break
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
