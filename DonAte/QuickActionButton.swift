import UIKit

// MARK: - QuickActionButton
// Custom button for quick actions on dashboard (Available Requests, Accepted Requests)

class QuickActionButton: UIButton {
    
    // MARK: - UI Components
    private let iconImageView = UIImageView()
    private let buttonTitleLabel = UILabel()  // ✅ Renamed to avoid conflict with UIButton's titleLabel
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    convenience init(icon: String, title: String) {
        self.init(frame: .zero)
        configure(icon: icon, title: title)
    }
    
    // MARK: - Setup
    private func setup() {
        // Button styling
        backgroundColor = .donateGreen
        layer.cornerRadius = 12
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Icon image view
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Title label - using custom name to avoid conflict
        buttonTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        buttonTitleLabel.textColor = .white
        buttonTitleLabel.textAlignment = .center
        buttonTitleLabel.numberOfLines = 2
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonTitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            buttonTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            buttonTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    func configure(icon: String, title: String) {
        iconImageView.image = UIImage(systemName: icon)
        buttonTitleLabel.text = title
    }
    
    // MARK: - Touch Animation
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.8 : 1.0
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
}
