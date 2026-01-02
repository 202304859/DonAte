//
//  UserTableViewCell.swift
//  DonAte
//
//  Created by Zahra Almosawi on 30/12/2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: CardsView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var donationNumLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage.layer.cornerRadius = 39.5
        avatarImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func configure(with user: User) {
        usernameLabel.text = user.name
        roleLabel.text = user.role
        emailLabel.text = user.email
        statusLabel.text = user.status
        
        if user.status == "Active" {
            statusImageView.tintColor = .color1
        } else {
            statusImageView.tintColor = .color3
        }
        
        // fix the User model !!
        //donationNumLabel.text = user.role == "Donor"? "\(user.donations) donations given" : "\(user.donations) donations received"
        
        
    }

}
