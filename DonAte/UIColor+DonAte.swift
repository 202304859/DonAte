// ============================================================================
// FILE 19: UIColor+DonAte.swift
// ============================================================================

import UIKit

extension UIColor {
    
    // Primary green color: #b4e7b4
    static let donateGreen = UIColor(hex: "b4e7b4")
    
    // Light green for backgrounds
    static let donateLightGreen = UIColor(hex: "b4e7b4").withAlphaComponent(0.2)
    
    // Background color
    static let donateBackground = UIColor(hex: "F2F2F2")
    
    // Convenience initializer for hex colors
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
