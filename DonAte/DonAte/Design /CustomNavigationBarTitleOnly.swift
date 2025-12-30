//
//  CustomNavigationBar.swift
//  DonAte
//
//  Created by Zahra Almosawi on 23/12/2025.
//

import UIKit

class CustomNavigationBarTitleOnly: UIView {
    
    //this file is for the top navigation with title but without the logo or the back button

    // MARK: -UI
    private let navBarView = UIView()
    private let containerView = UIView()
    //private let logoView = UIImageView()
    private let titleLabel = UILabel()
  //  private let backButton = UIButton(type: .system)
   // private var titleLeadingToBackButton: NSLayoutConstraint!
    private var titleLeadingToLogo: NSLayoutConstraint!
    private var titleLeadingToContainer: NSLayoutConstraint!

    
    
    // MARK: -Style
    enum Style {
        case backWithTitle(title: String)
        case titleOnly(title: String)
        case dashboard
    }
    
    var onBackTapped: (() -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        onBackTapped?()
    }

    private func setupView() {

        // Nav bar view
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        navBarView.backgroundColor = UIColor(red: 0.71, green: 0.902, blue: 0.686, alpha: 1)
        navBarView.layer.cornerRadius = 30
        navBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        addSubview(navBarView)

        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(containerView)

        // Logo
        /*
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.image = UIImage(named: "Logo")
        logoView.contentMode = .scaleAspectFit
        containerView.addSubview(logoView)*/

        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)
        titleLeadingToContainer = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            // Nav bar constraints
            navBarView.topAnchor.constraint(equalTo: topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 150),

            // Container constraints
            containerView.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 54),

            // Title constraints (IMPORTANT)
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])


        
        // Back button
        /*
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self,action: #selector(backButtonTapped(_:)),for: .touchUpInside)
        containerView.addSubview(backButton)
         */

        NSLayoutConstraint.activate([
            // Nav bar constraints
            navBarView.topAnchor.constraint(equalTo: topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 150),

            // Container constraints
            containerView.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 30),
            containerView.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 54),
            containerView.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 0),

            // Logo constraints
            /*
            logoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logoView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 54),
            logoView.heightAnchor.constraint(equalToConstant: 54),
             */

            // Title constraints
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            
            // Back button constraints
            /*
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
             */
        ])
        
        
        
        
    }
    
    
    func configure(title: String){
        titleLabel.isHidden = false
           titleLabel.text = title
             }
    }
    


