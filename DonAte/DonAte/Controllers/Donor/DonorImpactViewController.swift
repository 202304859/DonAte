//
//  DonorImpactViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class DonorImpactViewController: UIViewController {

    //@IBOutlet weak var rankCardView: UIView!
    // @IBOutlet weak var rankCardView: UIView!
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //this is for the border and stroke of the cards
       /* rankCardView.layer.cornerRadius = 21
            rankCardView.layer.borderWidth = 2
        if let cardColor = UIColor(named: "Color 1") {
                rankCardView.layer.borderColor = cardColor.cgColor
            } */
        
            let navBar = CustomNavigationBar()
            navBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navBar)
            
            NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalTo: view.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navBar.heightAnchor.constraint(equalToConstant: 150)
            ])
            
            navBar.configure(style: .backWithTitle(title: "Impact Summary"))
            navBar.onBackTapped = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
               
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    

    

}
