//
//  CardsView2.swift
//  DonAte
//
//  Created by Zahra Almosawi on 02/01/2026.
//

import UIKit

import UIKit

@IBDesignable
class CardView2: UIView {

    // MARK: - Styling
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet { updateUI() }
    }

    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet { updateUI() }
    }

    @IBInspectable var borderColor: UIColor = UIColor(
        red: 217/255,
        green: 217/255,
        blue: 217/255,
        alpha: 1
    ) {
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

    private func commonInit() {
        updateUI()
    }

    private func updateUI() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        layer.masksToBounds = false
        layer.shadowOpacity = 0   // no shadow
    }
}

