//
//  ReportDetailsViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class ReportDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        navBar.configure(style: .backWithTitle(title: "Report Details"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
