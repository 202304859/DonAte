//
//  AddressCardCellTableViewCell.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class AddressCardCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()

            // Make the cell background clear so it looks like floating cards
            backgroundColor = .clear
            contentView.backgroundColor = .clear

            // Remove gray selection look (optional)
            selectionStyle = .none
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            // Apply clean shadow to the card (bottom shadow like your design)
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.12
            cardView.layer.shadowRadius = 10
            cardView.layer.shadowOffset = CGSize(width: 0, height: 4)

            // Match the card's rounded shape for a clean shadow edge
            let radius = cardView.layer.cornerRadius
            cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds,
                                                    cornerRadius: radius).cgPath
        }

        // Fill labels from an Address-like object (we'll use this later for Firebase)
        func configure(title: String, details: String) {
            // Set card text
            titleLabel.text = title
            detailsLabel.text = details
        }

}
