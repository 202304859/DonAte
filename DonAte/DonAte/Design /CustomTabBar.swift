//
//  CustomTabBar.swift
//  DonAte
//
//  Created by Zahra Almosawi on 25/12/2025.
//

import UIKit

class CustomTabBar: UITabBar {

    
         var customHeight : CGFloat = 97
        
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
                var sizeThatFits = super.sizeThatFits(size)
                sizeThatFits.height = customHeight
                return sizeThatFits
            }

}
