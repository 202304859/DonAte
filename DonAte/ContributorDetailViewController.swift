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
        setupTransparentNavigationBar()
    }
    
    // MARK: - Create UI
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        title = "Contributor Details"
        
        // Large Green Header (like in screenshot)
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
            // Header - extends from very top of screen behind status bar
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Make header extend to safe area plus spacing
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Add spacing at top of content for breathable design
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
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
        
        // Food Types Chart Card (like in screenshot)
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
        
        // Calculate angles for each segment
        let foodData = contributor.foodTypes.chartData
        let total = foodData.reduce(0) { $0 + $1.value }
        
        var startAngle: CGFloat = -.pi / 2
        let colors: [UIColor] = [
            UIColor(hex: "b4e7b4"), // Green - Beverages
            UIColor(hex: "F44336"), // Red - Snacks & Sweets
            UIColor(hex: "FF9800"), // Orange - Baked Goods
            UIColor(hex: "2196F3")  // Blue - Meals
        ]
        
        for (index, item) in foodData.enumerated() {
            let percentage = CGFloat(item.value) / CGFloat(total)
            let endAngle = startAngle + (2 * .pi * percentage)
            
            let shapeLayer = CAShapeLayer()
            let center = CGPoint(x: 125, y: 125)
            let radius: CGFloat = 100
            let innerRadius: CGFloat = 65
            
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
            UIColor(hex: "b4e7b4"), // Green
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
