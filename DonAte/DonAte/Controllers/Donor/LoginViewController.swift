//
//  LoginViewController.swift
//  DonAte
//
//  Created by BP-36-201-05 on 10/12/2025.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
