//
//  CardsView.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class CardsView: UIView{

    // MARK: - Corner + Border
        @IBInspectable var cornerRadius: CGFloat = 21 {
            didSet { updateUI() }
        }

        @IBInspectable var borderWidth: CGFloat = 2 {
            didSet { updateUI() }
        }

        
        @IBInspectable var borderColorName: String = "Color 1" {
            didSet { updateUI() }
        }

        // MARK: - Shadow (optional)
        @IBInspectable var showShadow: Bool = true {
            didSet { updateUI() }
        }

        @IBInspectable var shadowOpacity: Float = 0.12 {
            didSet { updateUI() }
        }

        @IBInspectable var shadowRadius: CGFloat = 8 {
            didSet { updateUI() }
        }

        @IBInspectable var shadowOffsetY: CGFloat = 4 {
            didSet { updateUI() }
        }

        // MARK: - Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            updateUI()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            
            if showShadow {
                layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            }
        }

        private func commonInit() {
            updateUI()
        }

        private func updateUI() {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth

            if let c = UIColor(named: borderColorName) {
                layer.borderColor = c.cgColor
            } else {
                // fallback so it doesn't crash or look invisible
                layer.borderColor = UIColor.systemGreen.cgColor
            }

            if showShadow {
                layer.masksToBounds = false
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = shadowOpacity
                layer.shadowRadius = shadowRadius
                layer.shadowOffset = CGSize(width: 0, height: shadowOffsetY)
            } else {
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
                layer.shadowOffset = .zero
                layer.shadowColor = nil
                layer.masksToBounds = true // clips content to rounded corners
            }
        }
}
