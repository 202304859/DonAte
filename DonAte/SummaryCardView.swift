import UIKit

// MARK: - SummaryCardView
// Custom view for dashboard summary cards (Accepted, Completed, Active, Food Saved)

class SummaryCardView: UIView {
    
    // MARK: - UI Components
    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    convenience init(value: String, description: String) {
        self.init(frame: .zero)
        configure(value: value, description: description)
    }
    
    // MARK: - Setup
    private func setup() {
        // Card styling
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.donateGreen.cgColor
        
        // Value label
        valueLabel.font = .systemFont(ofSize: 32, weight: .bold)
        valueLabel.textColor = .donateGreen
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        // Description label
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Value label
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            // Description label
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(value: String, description: String) {
        valueLabel.text = value
        descriptionLabel.text = description
    }
    
    // MARK: - Animation
    func animateUpdate(to newValue: String) {
        UIView.transition(with: valueLabel,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.valueLabel.text = newValue
        })
        
        // Pulse animation
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
}
