import UIKit

class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    var onBackButtonTapped: (() -> Void)?
    var onRightButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(hex: "#FF6B6B")
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            rightButton.widthAnchor.constraint(equalToConstant: 44),
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightButton.leadingAnchor, constant: -8),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setRightButtonImage(named imageName: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        rightButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }
    
    func hideBackButton(_ hide: Bool) {
        backButton.isHidden = hide
    }
    
    func hideRightButton(_ hide: Bool) {
        rightButton.isHidden = hide
    }
    
    // MARK: - Actions
    @objc private func backButtonAction() {
        onBackButtonTapped?()
    }
    
    @objc private func rightButtonAction() {
        onRightButtonTapped?()
    }
}
