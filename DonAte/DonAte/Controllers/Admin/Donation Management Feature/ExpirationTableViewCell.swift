//
//  EpirationTableViewCell.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class ExpirationTableViewCell: UITableViewCell {

    @IBOutlet var checkButtons: [UIButton]?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCheckboxes()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCheckboxes() {
        checkButtons?.forEach { button in
            button.setImage(UIImage(systemName: "square"), for: .normal)
            button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            button.tintColor = .systemGray
            button.isSelected = false
        }
    }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
            sender.isSelected.toggle()
        }
    
    func configure(isChecked: Bool) {
        checkButtons?.forEach { button in
            button.isSelected = isChecked
        }
    }
    
    
}
