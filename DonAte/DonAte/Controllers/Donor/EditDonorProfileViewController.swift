//
//  EditDonorProfileViewController.swift
//  DonAte
//
//  Created by Guest 1 on 31/12/2025.
//

import UIKit

class EditDonorProfileViewController: UIViewController {
    
    
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
        
        navBar.configure(style: .titleOnly(title: "Edit Profile"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            
            // Do any additional setup after loading the view.
        }
        
        
       
        
    }
    
    
}
