import UIKit

class DashboardViewController: BaseViewController {
    
    // MARK: - UI Elements (Programmatic)
    private var headerView: UIView!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var summariesStackView: UIStackView!
    private var quickActionsStackView: UIStackView!
    private var donationsTableView: UITableView!
    private var tableHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var donations: [Donation] = []
    private let dataManager = DataManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        setupUI()
        setupSummaryCards()
        setupQuickActions()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        refreshData()
    }
    
    // MARK: - Create UI Programmatically
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        
        // Header View - extends into safe area for seamless transition
        headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "b4e7b4")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // ScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content View
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Dashboard"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Summaries Stack View
        summariesStackView = UIStackView()
        summariesStackView.axis = .vertical
        summariesStackView.spacing = 12
        summariesStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(summariesStackView)
        
        // Quick Actions Label
        let quickActionsLabel = UILabel()
        quickActionsLabel.text = "Quick Actions"
        quickActionsLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        quickActionsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quickActionsLabel)
        
        // Quick Actions Stack View
        quickActionsStackView = UIStackView()
        quickActionsStackView.axis = .horizontal
        quickActionsStackView.spacing = 12
        quickActionsStackView.distribution = .fillEqually
        quickActionsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quickActionsStackView)
        
        // Latest Donations Header
        let latestHeader = UIView()
        latestHeader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(latestHeader)
        
        let latestLabel = UILabel()
        latestLabel.text = "Latest Donations"
        latestLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        latestLabel.translatesAutoresizingMaskIntoConstraints = false
        latestHeader.addSubview(latestLabel)
        
        let seeMoreButton = UIButton(type: .system)
        seeMoreButton.setTitle("See More", for: .normal)
        seeMoreButton.setTitleColor(.donateGreen, for: .normal)
        seeMoreButton.addTarget(self, action: #selector(availableRequestsTapped), for: .touchUpInside)
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        latestHeader.addSubview(seeMoreButton)
        
        // Table View
        donationsTableView = UITableView()
        donationsTableView.translatesAutoresizingMaskIntoConstraints = false
        donationsTableView.separatorStyle = .none
        donationsTableView.backgroundColor = .clear
        donationsTableView.isScrollEnabled = false
        contentView.addSubview(donationsTableView)
        
        // Constraints
        tableHeightConstraint = donationsTableView.heightAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([
            // Header View - extends from very top of screen behind status bar
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Make header extend well below safe area for a spacious look
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Add more top spacing for modern breathable feel
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            summariesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summariesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summariesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quickActionsLabel.topAnchor.constraint(equalTo: summariesStackView.bottomAnchor, constant: 24),
            quickActionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            quickActionsStackView.topAnchor.constraint(equalTo: quickActionsLabel.bottomAnchor, constant: 12),
            quickActionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quickActionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quickActionsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            latestHeader.topAnchor.constraint(equalTo: quickActionsStackView.bottomAnchor, constant: 24),
            latestHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            latestHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            latestHeader.heightAnchor.constraint(equalToConstant: 30),
            
            latestLabel.leadingAnchor.constraint(equalTo: latestHeader.leadingAnchor),
            latestLabel.centerYAnchor.constraint(equalTo: latestHeader.centerYAnchor),
            
            seeMoreButton.trailingAnchor.constraint(equalTo: latestHeader.trailingAnchor),
            seeMoreButton.centerYAnchor.constraint(equalTo: latestHeader.centerYAnchor),
            
            donationsTableView.topAnchor.constraint(equalTo: latestHeader.bottomAnchor, constant: 12),
            donationsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            donationsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            donationsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            tableHeightConstraint
        ])
    }
    
    // MARK: - Setup
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupSummaryCards() {
        summariesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let stats = dataManager.getDashboardStats()
        
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        topRow.spacing = 12
        
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 12
        
        let acceptedCard = createSummaryCard(value: "\(stats.accepted)", label: "Accepted\ndonations")
        let completedCard = createSummaryCard(value: "\(stats.completed)", label: "Completed\ndonations")
        topRow.addArrangedSubview(acceptedCard)
        topRow.addArrangedSubview(completedCard)
        
        let activeCard = createSummaryCard(value: "\(stats.activePickups)", label: "Active\nPick ups")
        let foodCard = createSummaryCard(value: "\(stats.foodSaved)", label: "Food saved\n(kg)")
        bottomRow.addArrangedSubview(activeCard)
        bottomRow.addArrangedSubview(foodCard)
        
        summariesStackView.addArrangedSubview(topRow)
        summariesStackView.addArrangedSubview(bottomRow)
    }
    
    private func createSummaryCard(value: String, label: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.donateGreen.cgColor
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 32, weight: .bold)
        valueLabel.textColor = .donateGreen
        valueLabel.textAlignment = .center
        
        let descLabel = UILabel()
        descLabel.text = label
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .darkGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 2
        
        card.addSubview(valueLabel)
        card.addSubview(descLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            
            descLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            descLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            
            card.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        return card
    }
    
    private func setupQuickActions() {
        quickActionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let availableButton = createQuickActionButton(icon: "magnifyingglass", title: "Available Requests", color: .donateGreen)
        availableButton.addTarget(self, action: #selector(availableRequestsTapped), for: .touchUpInside)
        
        let acceptedButton = createQuickActionButton(icon: "checkmark.circle.fill", title: "Accepted Requests", color: .donateGreen)
        acceptedButton.addTarget(self, action: #selector(acceptedRequestsTapped), for: .touchUpInside)
        
        quickActionsStackView.addArrangedSubview(availableButton)
        quickActionsStackView.addArrangedSubview(acceptedButton)
    }
    
    private func createQuickActionButton(icon: String, title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.tintColor = .white
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        
        button.addSubview(imageView)
        button.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
        ])
        
        return button
    }
    
    private func setupTableView() {
        donationsTableView.delegate = self
        donationsTableView.dataSource = self
        donationsTableView.register(DonationCell.self, forCellReuseIdentifier: "DonationCell")
    }
    
    private func refreshData() {
        donations = Array(dataManager.getAvailableDonations().prefix(3))
        setupSummaryCards()
        donationsTableView.reloadData()
        updateTableHeight()
    }
    
    private func updateTableHeight() {
        tableHeightConstraint.constant = CGFloat(donations.count) * 100
    }
    
    // MARK: - Actions
    @objc private func availableRequestsTapped() {
        let vc = DonationListViewController()
        vc.listType = .available
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func acceptedRequestsTapped() {
        let vc = DonationListViewController()
        vc.listType = .accepted
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! DonationCell
        cell.configure(with: donations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DonationDetailViewController()
        vc.donation = donations[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
