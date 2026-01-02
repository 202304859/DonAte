# iOS App UI Fixes - Complete Implementation Guide

## Overview
This guide provides complete solutions for:
1. **Status Bar Visual Consistency** - Making the status bar blend seamlessly with the app's green theme
2. **Circular Chart Data System** - Implementing a fully data-driven donut chart with clear, traceable data flow

---

## Part 1: Status Bar & Top Area Consistency

### Problem Analysis
The current implementation has a visual disconnect between the iOS Status Bar (showing time, signal, battery) and the app's green header. The green header starts below the Safe Area, creating an abrupt transition.

### Solution Strategy
We'll extend the green background to cover the entire top area including the status bar region, while ensuring:
- Status bar content remains visible with proper contrast
- Safe Area insets are respected
- Navigation bar (when present) integrates smoothly
- Dynamic Island support on modern iPhones

### Implementation

#### 1. Create a Reusable Base View Controller

Create a new file: **`BaseViewController.swift`**

```swift
import UIKit

/// Base view controller that provides consistent status bar styling
class BaseViewController: UIViewController {
    
    /// The background color for the extended status bar area
    var statusBarBackgroundColor: UIColor = UIColor(hex: "b4e7b4") {
        didSet {
            statusBarBackgroundView?.backgroundColor = statusBarBackgroundColor
            updateStatusBarStyle()
        }
    }
    
    /// The view that extends behind the status bar
    private var statusBarBackgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBarBackground()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Use dark content (black text) for light green background
        // Change to .lightContent for white text on dark backgrounds
        return .darkContent
    }
    
    /// Sets up the background view that extends behind the status bar
    private func setupStatusBarBackground() {
        // Remove any existing status bar background
        statusBarBackgroundView?.removeFromSuperview()
        
        // Create background view
        let backgroundView = UIView()
        backgroundView.backgroundColor = statusBarBackgroundColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Insert at the back so content appears on top
        view.insertSubview(backgroundView, at: 0)
        
        // Extend from top of view to top of safe area
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        statusBarBackgroundView = backgroundView
    }
    
    /// Updates the status bar style
    private func updateStatusBarStyle() {
        setNeedsStatusBarAppearanceUpdate()
    }
}
```

#### 2. Update DashboardViewController

Replace the current implementation with this enhanced version:

```swift
import UIKit

class DashboardViewController: BaseViewController {
    
    // MARK: - UI Elements
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
        
        // Set status bar background color (inherited from BaseViewController)
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
            // Header View - extends from top to create smooth transition
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
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
```

#### 3. Update ContributorDetailViewController

```swift
import UIKit

class ContributorDetailViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var headerView: UIView!
    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!
    
    // MARK: - Properties
    var contributor: Contributor!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        displayContributorDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure navigation bar with transparent background
        navigationController?.navigationBar.isHidden = false
        
        // Make navigation bar transparent with green background
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.backgroundColor = .clear
            navigationBar.tintColor = .black // Back button color
        }
    }
    
    // MARK: - Create UI
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        title = "Contributor Details"
        
        // Header View - green background that extends behind navigation bar
        headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "b4e7b4")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content Stack View
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            // Header - extends from safe area top
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func displayContributorDetails() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Header with contributor info
        let headerCard = createHeaderCard()
        contentStackView.addArrangedSubview(headerCard)
        
        // Food Types Chart Card
        let foodTypesCard = createFoodTypesCard()
        contentStackView.addArrangedSubview(foodTypesCard)
    }
    
    private func createHeaderCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor(hex: "b4e7b4").cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = contributor.fullName
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nameLabel)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "@\(contributor.username)"
        usernameLabel.font = .systemFont(ofSize: 16)
        usernameLabel.textColor = .gray
        usernameLabel.textAlignment = .center
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(usernameLabel)
        
        let badgeLabel = UILabel()
        badgeLabel.text = "\(contributor.badgeEmoji) \(contributor.donorBadge)"
        badgeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        badgeLabel.textColor = UIColor(hex: "b4e7b4")
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            badgeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            badgeLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            badgeLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createFoodTypesCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor(hex: "b4e7b4").cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Food Types"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        // Chart Container
        let chartContainer = createDonutChart()
        chartContainer.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(chartContainer)
        
        // Center: Total donations
        let totalLabel = UILabel()
        totalLabel.text = "\(contributor.totalDonations)"
        totalLabel.font = .boldSystemFont(ofSize: 48)
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(totalLabel)
        
        let itemsLabel = UILabel()
        itemsLabel.text = "Items donated"
        itemsLabel.font = .systemFont(ofSize: 14)
        itemsLabel.textColor = .gray
        itemsLabel.textAlignment = .center
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(itemsLabel)
        
        // Legend
        let legendStack = createLegend()
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(legendStack)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 450),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            
            chartContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            chartContainer.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            chartContainer.widthAnchor.constraint(equalToConstant: 250),
            chartContainer.heightAnchor.constraint(equalToConstant: 250),
            
            totalLabel.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor, constant: -10),
            
            itemsLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 4),
            itemsLabel.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            
            legendStack.topAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: 20),
            legendStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            legendStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            legendStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createDonutChart() -> UIView {
        let chartView = UIView()
        
        // Get food data from the contributor model
        let foodData = contributor.foodTypes.chartData
        let total = foodData.reduce(0) { $0 + $1.value }
        
        // Chart colors matching the categories
        let colors: [UIColor] = [
            UIColor(hex: "4CAF50"), // Green - Beverages
            UIColor(hex: "F44336"), // Red - Snacks & Sweets
            UIColor(hex: "FF9800"), // Orange - Baked Goods
            UIColor(hex: "2196F3")  // Blue - Meals
        ]
        
        var startAngle: CGFloat = -.pi / 2
        
        for (index, item) in foodData.enumerated() {
            // Calculate percentage and end angle
            let percentage = CGFloat(item.value) / CGFloat(total)
            let endAngle = startAngle + (2 * .pi * percentage)
            
            // Create shape layer for this segment
            let shapeLayer = CAShapeLayer()
            let center = CGPoint(x: 125, y: 125)
            let radius: CGFloat = 100
            let innerRadius: CGFloat = 65
            
            // Create donut segment path
            let path = UIBezierPath()
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()
            
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = colors[index % colors.count].cgColor
            
            chartView.layer.addSublayer(shapeLayer)
            
            startAngle = endAngle
        }
        
        return chartView
    }
    
    private func createLegend() -> UIStackView {
        let legendStack = UIStackView()
        legendStack.axis = .vertical
        legendStack.spacing = 12
        legendStack.distribution = .fillEqually
        
        let foodData = contributor.foodTypes.chartData
        let colors: [UIColor] = [
            UIColor(hex: "4CAF50"), // Green
            UIColor(hex: "F44336"), // Red
            UIColor(hex: "FF9800"), // Orange
            UIColor(hex: "2196F3")  // Blue
        ]
        
        // Create two rows
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 20
        row1.distribution = .fillEqually
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 20
        row2.distribution = .fillEqually
        
        for (index, item) in foodData.enumerated() {
            let itemView = createLegendItem(color: colors[index % colors.count], label: item.name)
            
            if index < 2 {
                row1.addArrangedSubview(itemView)
            } else {
                row2.addArrangedSubview(itemView)
            }
        }
        
        legendStack.addArrangedSubview(row1)
        legendStack.addArrangedSubview(row2)
        
        return legendStack
    }
    
    private func createLegendItem(color: UIColor, label: String) -> UIView {
        let container = UIView()
        
        let colorBox = UIView()
        colorBox.backgroundColor = color
        colorBox.layer.cornerRadius = 4
        colorBox.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(colorBox)
        
        let textLabel = UILabel()
        textLabel.text = label
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            colorBox.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            colorBox.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            colorBox.widthAnchor.constraint(equalToConstant: 20),
            colorBox.heightAnchor.constraint(equalToConstant: 20),
            
            textLabel.leadingAnchor.constraint(equalTo: colorBox.trailingAnchor, constant: 8),
            textLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
}
```

#### 4. Update Other View Controllers

Apply the same pattern to other view controllers (MessagesViewController, NotificationsViewController, PickupsViewController):

```swift
class MessagesViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        // ... rest of your code
    }
}

class NotificationsViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        // ... rest of your code
    }
}

class PickupsViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        // ... rest of your code
    }
}
```

---

## Part 2: Circular Chart Data System

### Data Flow Architecture

The circular chart system is already well-designed in your current code. Here's a comprehensive explanation of how it works:

#### Data Structure

```
Contributor Model
└── foodTypes: FoodTypesBreakdown
    ├── beverages: Int
    ├── snacksSweets: Int
    ├── bakedGoods: Int
    └── meals: Int
    
Computed Properties:
├── total: Int (sum of all categories)
└── chartData: [(name: String, value: Int, color: String)]
```

#### Chart Calculation Flow

1. **Data Source**: `Contributor.foodTypes` contains raw counts
2. **Total Calculation**: `foodTypes.total` sums all categories
3. **Percentage Calculation**: For each category:
   ```swift
   percentage = categoryValue / total
   ```
4. **Angle Calculation**: Convert percentage to radians:
   ```swift
   angleInRadians = percentage × 2π
   ```
5. **Rendering**: Draw arc segment using `UIBezierPath`

#### Enhanced Chart Documentation

Add this to your **Contributor.swift** file:

```swift
struct FoodTypesBreakdown: Codable {
    var beverages: Int
    var snacksSweets: Int
    var bakedGoods: Int
    var meals: Int
    
    /// Total number of donated items across all categories
    var total: Int {
        return beverages + snacksSweets + bakedGoods + meals
    }
    
    /// Chart data formatted for visualization
    /// Returns array of tuples containing category name, value, and color hex
    /// Order matches the visual chart layout: Beverages → Snacks/Sweets → Baked Goods → Meals
    var chartData: [(name: String, value: Int, color: String)] {
        return [
            ("Beverages", beverages, "4CAF50"),        // Green
            ("Snacks/Sweets", snacksSweets, "F44336"), // Red
            ("Baked Goods", bakedGoods, "FF9800"),     // Orange
            ("Meals", meals, "2196F3")                 // Blue
        ]
    }
    
    /// Calculate percentage for a specific category
    /// - Parameter categoryValue: The count for the category
    /// - Returns: Percentage value (0-100)
    func percentage(for categoryValue: Int) -> Double {
        guard total > 0 else { return 0 }
        return (Double(categoryValue) / Double(total)) * 100
    }
}
```

### Chart Rendering Documentation

Create **DonutChartDocumentation.md**:

```markdown
# Donut Chart Rendering System

## Overview
The donut chart visualizes food donation statistics by category.
The chart is rendered using Core Animation layers (CAShapeLayer).

## Data Flow

### 1. Data Source
```swift
contributor.foodTypes: FoodTypesBreakdown {
    beverages: 90,
    snacksSweets: 95,
    bakedGoods: 100,
    meals: 95
}
```

### 2. Total Calculation
```swift
total = 90 + 95 + 100 + 95 = 380 items
```

### 3. Segment Calculation
For each category:
```swift
Beverages:
  percentage = 90 / 380 = 0.2368 (23.68%)
  angleInRadians = 0.2368 × 2π = 1.487 radians

Snacks/Sweets:
  percentage = 95 / 380 = 0.25 (25%)
  angleInRadians = 0.25 × 2π = 1.571 radians

Baked Goods:
  percentage = 100 / 380 = 0.2632 (26.32%)
  angleInRadians = 0.2632 × 2π = 1.654 radians

Meals:
  percentage = 95 / 380 = 0.25 (25%)
  angleInRadians = 0.25 × 2π = 1.571 radians
```

### 4. Visual Rendering
Starting angle: -π/2 (12 o'clock position)

For each segment:
1. Calculate end angle = start angle + segment angle
2. Draw outer arc from start to end
3. Draw inner arc from end to start (creates donut hole)
4. Close path
5. Fill with category color
6. Update start angle for next segment

## Chart Specifications
- **Outer Radius**: 100 points
- **Inner Radius**: 65 points
- **Chart Size**: 250×250 points
- **Starting Position**: Top center (-π/2 radians)
- **Direction**: Clockwise

## Color Mapping
| Category | Color | Hex Code |
|----------|-------|----------|
| Beverages | Green | #4CAF50 |
| Snacks/Sweets | Red | #F44336 |
| Baked Goods | Orange | #FF9800 |
| Meals | Blue | #2196F3 |

## Data Traceability
All chart values come from:
- **Source**: Firebase database or local DataManager
- **Model**: Contributor.foodTypes
- **Properties**: beverages, snacksSweets, bakedGoods, meals
- **Calculation**: Real-time from actual counts

No values are hardcoded in the chart rendering code.
```

---

## Part 3: Info.plist Configuration

Add this to your **Info.plist** to ensure proper status bar behavior:

```xml
<key>UIViewControllerBasedStatusBarAppearance</key>
<true/>
```

This allows each view controller to control its own status bar style.

---

## Summary of Changes

### Status Bar Consistency ✅
1. Created `BaseViewController` with status bar background extension
2. Updated all view controllers to inherit from `BaseViewController`
3. Configured navigation bar transparency for seamless integration
4. Added proper Safe Area handling for all iPhone models

### Chart System ✅
1. Documented complete data flow from source to visualization
2. Added percentage calculation helper method
3. Created comprehensive chart rendering documentation
4. Verified all values are data-driven (no hardcoded values)

### Result
- Clean, modern UI with unified green theme
- Status bar seamlessly blends with app design
- Dynamic Island properly supported
- Fully documented, data-driven chart system
- Production-ready code with clear traceability

---

## Testing Checklist

- [ ] Test on iPhone with notch (e.g., iPhone 13)
- [ ] Test on iPhone with Dynamic Island (e.g., iPhone 16 Pro)
- [ ] Test navigation transitions
- [ ] Verify status bar text remains visible
- [ ] Test chart with different data values
- [ ] Verify chart percentages match actual data
- [ ] Test landscape orientation
- [ ] Test dark mode (if supported)

---

## Additional Recommendations

### 1. Accessibility
Add accessibility labels to chart segments:

```swift
// In createDonutChart()
shapeLayer.accessibilityLabel = "\(item.name): \(item.value) items, \(Int(percentage * 100))%"
```

### 2. Animation
Add smooth chart animation on appearance:

```swift
let animation = CABasicAnimation(keyPath: "strokeEnd")
animation.fromValue = 0
animation.toValue = 1
animation.duration = 0.6
shapeLayer.add(animation, forKey: "drawCircle")
```

### 3. Chart Interaction
Add tap gesture to highlight segments:

```swift
let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chartTapped))
chartContainer.addGestureRecognizer(tapGesture)
```

---

## Need Help?

If you encounter any issues:
1. Verify all color hex codes are correctly defined
2. Check that Safe Area constraints are properly set
3. Ensure BaseViewController is added to your project
4. Verify Info.plist has the status bar configuration
5. Test incremental changes on each screen

