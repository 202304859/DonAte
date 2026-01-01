//
//  ShadowButton.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import Foundation

import UIKit

extension UIButton {

    // Applies a shadow only to the bottom-right of the button
    func applyBottomRightShadow(){
    layer.masksToBounds = false

            layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 5)

        }

        /// Must be called after layout for rounded buttons
        func updateCleanShadowPath() {
            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: bounds.height / 2 // pill button
            ).cgPath
    }
}

