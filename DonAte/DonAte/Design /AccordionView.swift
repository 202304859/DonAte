//
//  FilterSheetView.swift
//  DonAte
//
//  Created by Zahra Almosawi on 01/01/2026.
//

import UIKit

@IBDesignable
class AccordionView: UIView {
    
    
        @IBOutlet weak var headerView: UIView!
        @IBOutlet weak var chevronImageView: UIImageView!
        @IBOutlet weak var contentView: UIView!
        @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!

    

        private(set) var isExpanded = false

        override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }

        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            setupUI()
        }

        private func setupUI() {
            // Header styling
            headerView.layer.cornerRadius = 8
            headerView.layer.borderWidth = 1
            headerView.layer.borderColor = UIColor(
                red: 217/255,
                green: 217/255,
                blue: 217/255,
                alpha: 1
            ).cgColor
            headerView.layer.masksToBounds = false

            // Chevron
            chevronImageView.tintColor = .label

            // Start collapsed
            contentHeightConstraint.constant = 0
            contentView.clipsToBounds = true
        }
    
    


}
