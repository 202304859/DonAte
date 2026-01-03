//
//  CustomTabBar.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {

    
         var customHeight : CGFloat = 97
        
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
                var sizeThatFits = super.sizeThatFits(size)
                sizeThatFits.height = customHeight
                return sizeThatFits
            }

}
