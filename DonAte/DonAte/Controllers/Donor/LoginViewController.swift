//
//  LoginViewController.swift
//  DonAte
//
//  Created by BP-36-201-05 on 10/12/2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

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
                    
                
      /*  let alert = UIAlertController(
               title: "Loaded",
               message: "LoginViewController is linked correctly",
               preferredStyle: .alert
           )

           alert.addAction(UIAlertAction(title: "OK", style: .default))

           present(alert, animated: true)*/
        //the above was just to test if the viewController is correctly linked to the storyboard. i have trust issues.
        
    }
    

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        //check user role
        
        let storyboard = UIStoryboard(name: "DonorDashboard", bundle: nil)
        
        let tab_bar = storyboard.instantiateViewController(withIdentifier: "donor_tab") as! DonorTabBarController
        
        tab_bar.modalPresentationStyle = .fullScreen
        
        present(tab_bar, animated: true)
        
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
