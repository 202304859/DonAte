//
//  RegistrationViewController.swift
//  DonAte
//
//  Created by Guest 1 on 29/12/2025.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

                navBar.configure(style: .donate)
 

        // Do any additional setup after loading the view.
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
