//
//  generalCardView.swift
//  DonAte
//
//  Created by Zahra Almosawi on 01/01/2026.
//

import UIKit

class generalCardView: UIView {
    
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.color1.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.clipsToBounds = false
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        
        return view
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
   
