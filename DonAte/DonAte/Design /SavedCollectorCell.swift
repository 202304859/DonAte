//
//  SavedCollectorCell.swift
//  DonAte
//
//  Created by Guest 1 on 02/01/2026.
//

import UIKit

class SavedCollectorCell: UITableViewCell {
    
    @IBOutlet weak var collectorImageView: UIImageView!
    
    @IBOutlet weak var cardView: CardsView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Remove default cell background
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Make the profile image circular
        collectorImageView.layer.cornerRadius = collectorImageView.bounds.width / 2
        collectorImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure circle stays correct after layout
        collectorImageView.layer.cornerRadius = collectorImageView.bounds.width / 2
    }
    
    func configure(name: String, image: UIImage?) {
        // Set collector name
        nameLabel.text = name
        
        // Set profile image
        collectorImageView.image = image
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
