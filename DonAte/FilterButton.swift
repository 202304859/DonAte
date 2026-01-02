import UIKit

// MARK: - FilterButton
// Custom button for message filters (All, Admin, Donor)

class FilterButton: UIButton {
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(type: .custom)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        // Button styling
        layer.cornerRadius = 20
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        // Set constraints
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        // Initial appearance
        updateAppearance()
    }
    
    private func updateAppearance() {
        if isSelected {
            // Selected state: Green background, white text
            backgroundColor = .donateGreen
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        } else {
            // Unselected state: White background, green text, green border
            backgroundColor = .white
            setTitleColor(.donateGreen, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.donateGreen.cgColor
        }
        // Ensure the colors are set immediately
        layoutIfNeeded()
    }
    
    // MARK: - Animation on Touch
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
}
