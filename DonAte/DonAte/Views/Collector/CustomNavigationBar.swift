//
//  CustomNavigationBar.swift
//  DonAte
//
//  Barre de navigation personnalisée avec design DonAte
//  Couleurs: Vert DonAte (0xB5E6AA), coins arrondis en bas
//

import UIKit

/// Style de navigation pour CustomNavigationBar
enum NavigationStyle {
    case logoWithTitle
    case backWithTitle(title: String)
    case titleOnly(title: String)
}

/// Barre de navigation personnalisée avec design DonAte
class CustomNavigationBar: UIView {
    
    // MARK: - Constantes
    
    private let navBarHeight: CGFloat = 150
    private let containerLeadingPadding: CGFloat = 30
    private let containerTrailingPadding: CGFloat = -30
    private let containerBottomPadding: CGFloat = -20
    private let containerHeight: CGFloat = 54
    private let iconSize: CGFloat = 24
    private let logoSize: CGFloat = 54
    
    // MARK: - UI Components
    
    private lazy var navBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.71, green: 0.902, blue: 0.686, alpha: 1.0)
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "leaf.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = .black
        return button
    }()
    
    // Vues de contenu (créées dynamiquement)
    private var contentViews: [UIView] = []
    
    // MARK: - Properties
    
    var onBackTapped: (() -> Void)?
    var onRightButtonTapped: (() -> Void)?
    
    private var currentStyle: NavigationStyle = .titleOnly(title: "")
    private var currentRightButtonTitle: String?
    private var currentRightButtonAction: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(navBarView)
        navBarView.addSubview(containerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Navigation bar container
            navBarView.topAnchor.constraint(equalTo: topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: navBarHeight),
            
            // Container view
            containerView.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: containerLeadingPadding),
            containerView.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: containerBottomPadding),
            containerView.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: containerTrailingPadding),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(style: NavigationStyle, rightButtonTitle: String? = nil, rightButtonAction: (() -> Void)? = nil) {
        currentStyle = style
        currentRightButtonTitle = rightButtonTitle
        currentRightButtonAction = rightButtonAction
        
        // Nettoyer les sous-vues précédentes
        cleanupContentViews()
        
        // Ajouter les sous-vues selon le style
        switch style {
        case .logoWithTitle:
            configureLogoWithTitle()
            
        case .backWithTitle(let title):
            configureBackWithTitle(title: title)
            
        case .titleOnly(let title):
            configureTitleOnly(title: title)
        }
        
        // Configurer le bouton droit si présent
        if let rightTitle = rightButtonTitle {
            configureRightButton(title: rightTitle, action: rightButtonAction)
        }
    }
    
    private func cleanupContentViews() {
        contentViews.forEach { $0.removeFromSuperview() }
        contentViews.removeAll()
    }
    
    private func addContentView(_ view: UIView) {
        containerView.addSubview(view)
        contentViews.append(view)
    }
    
    private func configureLogoWithTitle() {
        addContentView(logoImageView)
        addContentView(titleLabel)
        
        titleLabel.text = "DonAte"
        titleLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func configureBackWithTitle(title: String) {
        addContentView(backButton)
        addContentView(titleLabel)
        
        titleLabel.text = title
        titleLabel.textAlignment = .left
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: iconSize),
            backButton.heightAnchor.constraint(equalToConstant: iconSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func configureTitleOnly(title: String) {
        addContentView(titleLabel)
        
        titleLabel.text = title
        titleLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func configureRightButton(title: String, action: (() -> Void)?) {
        navBarView.addSubview(rightButton)
        contentViews.append(rightButton)
        
        rightButton.setTitle(title, for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -30),
            rightButton.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -20),
            rightButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.onRightButtonTapped = action
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        onBackTapped?()
    }
    
    @objc private func rightButtonTapped() {
        onRightButtonTapped?()
    }
    
    // MARK: - Public Methods
    
    func updateRightButton(title: String) {
        rightButton.setTitle(title, for: .normal)
    }
    
    func hideBackButton(_ hide: Bool) {
        backButton.isHidden = hide
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
