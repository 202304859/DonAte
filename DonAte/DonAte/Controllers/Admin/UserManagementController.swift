//
//  UserManagementController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 23/12/2025.
//

import UIKit

class UserManagementController: UIViewController {
    
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

        navBar.configure(style: .titleOnly(title: "User Management"))
       

        
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
