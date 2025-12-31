//
//  ImpactSummaryViewController.swift
//  DonAte
//
//  ✅ REDESIGNED to match screenshot - Food Donation Theme
//  Created by Claude on 31/12/2025.
//

import UIKit

class ImpactSummaryViewController: UIViewController {
    
    // MARK: - Dummy Outlets (for storyboard compatibility)
    @IBOutlet weak var impactScoreLabel: UILabel?
    @IBOutlet weak var circularProgressView: UIView?
    @IBOutlet weak var totalDonationsLabel: UILabel?
    @IBOutlet weak var totalMealsLabel: UILabel?
    @IBOutlet weak var foodSavedLabel: UILabel?
    @IBOutlet weak var co2SavedLabel: UILabel?
    @IBOutlet weak var impactChartView: UIView?
    @IBOutlet weak var monthlyStatsTableView: UITableView?
    @IBOutlet weak var shareButton: UIButton?
    @IBOutlet weak var closeButton: UIButton?
    
    // MARK: - Properties
    var userProfile: UserProfile?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("✅ ImpactSummaryViewController loaded")
        
        // Hide storyboard elements
        hideStoryboardElements()
        
        // Create new UI matching screenshot
        setupUI()
    }
    
    private func hideStoryboardElements() {
        impactScoreLabel?.isHidden = true
        circularProgressView?.isHidden = true
        totalDonationsLabel?.isHidden = true
        totalMealsLabel?.isHidden = true
        foodSavedLabel?.isHidden = true
        co2SavedLabel?.isHidden = true
        impactChartView?.isHidden = true
        monthlyStatsTableView?.isHidden = true
        shareButton?.isHidden = true
        closeButton?.isHidden = true
    }
    
    private func setupUI() {
        title = "Impact summary"
        view.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.95, alpha: 1.0) // Light green background
        
        // Add back button
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissScreen))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        guard let profile = userProfile else {
            print("⚠️ WARNING: userProfile is nil!")
            return
        }
        
        print("✅ User profile loaded: \(profile.fullName)")
        
        // Create scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Track your contributions and see the\ndifference you're making"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Food Types Card (Circular pie chart)
        let foodTypesCard = createFoodTypesCard(donations: profile.totalDonations)
        contentView.addSubview(foodTypesCard)
        
        // Donations Accepted Card (Circular progress)
        let donationsRate = min(91, profile.totalDonations * 9) // Mock percentage
        let donationsCard = createCircularProgressCard(
            title: "Donations Accepted",
            percentage: donationsRate,
            subtitle: "Great! you have a lot more people.",
            color: UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        )
        contentView.addSubview(donationsCard)
        
        // Meals Provided Card (Semi-circular gauge)
        let mealsPercentage = min(100, (profile.totalMealsProvided * 100) / max(100, profile.totalMealsProvided))
        let mealsCard = createGaugeCard(
            title: "Meals Provided",
            value: profile.totalMealsProvided,
            percentage: mealsPercentage,
            subtitle: "Your efforts have helped so people!",
            color: UIColor.systemRed
        )
        contentView.addSubview(mealsCard)
        
        // Food Saved Card (Semi-circular gauge)
        let foodSaved = profile.totalDonations * 2 // kg
        let foodPercentage = min(100, (foodSaved * 100) / max(100, foodSaved))
        let foodCard = createGaugeCard(
            title: "Food Saved",
            value: foodSaved,
            percentage: foodPercentage,
            subtitle: "Fantastic! You've saved \(foodSaved) kg of food from going to waste!",
            color: UIColor.systemOrange
        )
        contentView.addSubview(foodCard)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            foodTypesCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            foodTypesCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            foodTypesCard.widthAnchor.constraint(equalToConstant: 350),
            foodTypesCard.heightAnchor.constraint(equalToConstant: 320),
            
            donationsCard.topAnchor.constraint(equalTo: foodTypesCard.bottomAnchor, constant: 20),
            donationsCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            donationsCard.widthAnchor.constraint(equalToConstant: 350),
            donationsCard.heightAnchor.constraint(equalToConstant: 150),
            
            mealsCard.topAnchor.constraint(equalTo: donationsCard.bottomAnchor, constant: 20),
            mealsCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mealsCard.widthAnchor.constraint(equalToConstant: 350),
            mealsCard.heightAnchor.constraint(equalToConstant: 150),
            
            foodCard.topAnchor.constraint(equalTo: mealsCard.bottomAnchor, constant: 20),
            foodCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            foodCard.widthAnchor.constraint(equalToConstant: 350),
            foodCard.heightAnchor.constraint(equalToConstant: 150),
            foodCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        print("✅ UI created successfully")
    }
    
    // MARK: - Create Food Types Card (Pie Chart)
    private func createFoodTypesCard(donations: Int) -> UIView {
        let card = createWhiteCard()
        
        let titleLabel = UILabel()
        titleLabel.text = "Food Types"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        // Pie chart view
        let pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.totalValue = donations
        card.addSubview(pieChartView)
        
        // Legend
        let legendStack = UIStackView()
        legendStack.axis = .horizontal
        legendStack.distribution = .equalSpacing
        legendStack.spacing = 10
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        
        let legends = [
            ("Beverages", UIColor.systemGreen),
            ("Bakery & Sweets", UIColor.systemRed),
            ("Baked Goods", UIColor.systemOrange),
            ("Meals", UIColor.systemBlue)
        ]
        
        for (title, color) in legends {
            let item = createLegendItem(title: title, color: color)
            legendStack.addArrangedSubview(item)
        }
        
        card.addSubview(legendStack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            
            pieChartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pieChartView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            pieChartView.widthAnchor.constraint(equalToConstant: 180),
            pieChartView.heightAnchor.constraint(equalToConstant: 180),
            
            legendStack.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 20),
            legendStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            legendStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])
        
        return card
    }
    
    // MARK: - Create Circular Progress Card
    private func createCircularProgressCard(title: String, percentage: Int, subtitle: String, color: UIColor) -> UIView {
        let card = createWhiteCard()
        
        let circularProgress = CircularProgressView()
        circularProgress.translatesAutoresizingMaskIntoConstraints = false
        circularProgress.lineWidth = 10
        circularProgress.progressColor = color
        circularProgress.trackColor = color.withAlphaComponent(0.2)
        card.addSubview(circularProgress)
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmark.tintColor = color
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        circularProgress.addSubview(checkmark)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let percentLabel = UILabel()
        percentLabel.text = "\(percentage)%"
        percentLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(percentLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            circularProgress.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            circularProgress.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            circularProgress.widthAnchor.constraint(equalToConstant: 80),
            circularProgress.heightAnchor.constraint(equalToConstant: 80),
            
            checkmark.centerXAnchor.constraint(equalTo: circularProgress.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: circularProgress.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 30),
            checkmark.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: circularProgress.trailingAnchor, constant: 20),
            
            percentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            percentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15)
        ])
        
        circularProgress.setProgress(CGFloat(percentage) / 100.0, animated: true)
        
        return card
    }
    
    // MARK: - Create Gauge Card (Semi-circular)
    private func createGaugeCard(title: String, value: Int, percentage: Int, subtitle: String, color: UIColor) -> UIView {
        let card = createWhiteCard()
        
        let gaugeView = SemiCircularGaugeView()
        gaugeView.translatesAutoresizingMaskIntoConstraints = false
        gaugeView.progressColor = color
        gaugeView.trackColor = color.withAlphaComponent(0.2)
        card.addSubview(gaugeView)
        
        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        valueLabel.textColor = color
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        gaugeView.addSubview(valueLabel)
        
        let percentLabel = UILabel()
        percentLabel.text = "\(percentage)%"
        percentLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        gaugeView.addSubview(percentLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            gaugeView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            gaugeView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            gaugeView.widthAnchor.constraint(equalToConstant: 100),
            gaugeView.heightAnchor.constraint(equalToConstant: 80),
            
            valueLabel.centerXAnchor.constraint(equalTo: gaugeView.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: gaugeView.centerYAnchor, constant: -5),
            
            percentLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -5),
            percentLabel.centerXAnchor.constraint(equalTo: gaugeView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: gaugeView.trailingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15)
        ])
        
        gaugeView.setProgress(CGFloat(percentage) / 100.0, animated: true)
        
        return card
    }
    
    // MARK: - Helper Functions
    private func createWhiteCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    private func createLegendItem(title: String, color: UIColor) -> UIView {
        let container = UIView()
        
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 4
        dot.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(dot)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            dot.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dot.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 8),
            dot.heightAnchor.constraint(equalToConstant: 8),
            
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    // MARK: - Actions
    @IBAction func dismissScreen(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Pie Chart View
class PieChartView: UIView {
    var totalValue: Int = 164
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isOpaque = false
        clipsToBounds = false
    }
    
    override func draw(_ rect: CGRect) {
        // Ensure completely transparent background
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        
        let segments: [(CGFloat, UIColor)] = [
            (0.25, .systemGreen),    // Beverages
            (0.25, .systemRed),      // Bakery
            (0.25, .systemOrange),   // Baked Goods
            (0.25, .systemBlue)      // Meals
        ]
        
        var startAngle: CGFloat = -.pi / 2
        
        for (proportion, color) in segments {
            let endAngle = startAngle + (2 * .pi * proportion)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            color.setFill()
            path.fill()
            
            startAngle = endAngle
        }
        
        // Center circle (white)
        let centerCircle = UIBezierPath(arcCenter: center, radius: radius * 0.6, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setFill()
        centerCircle.fill()
        
        // Draw value in center
        let text = "\(totalValue)" as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(x: center.x - textSize.width / 2, y: center.y - textSize.height / 2, width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: attributes)
        
        // Draw "Food" label
        let foodText = "Food" as NSString
        let foodAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        let foodSize = foodText.size(withAttributes: foodAttributes)
        let foodRect = CGRect(x: center.x - foodSize.width / 2, y: center.y + textSize.height / 2 - 5, width: foodSize.width, height: foodSize.height)
        foodText.draw(in: foodRect, withAttributes: foodAttributes)
    }
}

// MARK: - Circular Progress View
class CircularProgressView: UIView {
    var lineWidth: CGFloat = 10
    var progressColor: UIColor = .green
    var trackColor: UIColor = .lightGray
    private var progress: CGFloat = 0.0
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = .clear
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: 1.5 * .pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress
    }
    
    func setProgress(_ newProgress: CGFloat, animated: Bool) {
        let clampedProgress = min(max(newProgress, 0), 1)
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = clampedProgress
            animation.duration = 1.0
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progress = clampedProgress
        progressLayer.strokeEnd = progress
    }
}

// MARK: - Semi-Circular Gauge View
class SemiCircularGaugeView: UIView {
    var progressColor: UIColor = .systemRed
    var trackColor: UIColor = .lightGray
    private var progress: CGFloat = 0.0
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = .clear
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.maxY)
        let radius = min(bounds.width, bounds.height * 2) / 2 - 10
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 8
        trackLayer.lineCap = .round
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 8
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress
    }
    
    func setProgress(_ newProgress: CGFloat, animated: Bool) {
        let clampedProgress = min(max(newProgress, 0), 1)
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = clampedProgress
            animation.duration = 1.0
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progress = clampedProgress
        progressLayer.strokeEnd = progress
    }
}
