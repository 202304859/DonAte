//
//  DBioAuthViewController.swift
//  DonAte
//
//  Created by Guest 1 on 02/01/2026.
//

import UIKit

class DBioAuthViewController: UITableViewController {
    
    
    
    @IBOutlet weak var biometricSwitch: UISwitch!
    
    @IBAction func biometricsSwitchChanged(_ sender: UISwitch) {
   
        //Save new state
            UserDefaults.standard.set(sender.isOn, forKey: "biometricEnabled")

            //Show confirmation alert
            let message = sender.isOn
                ? "Biometric authentication has been enabled."
                : "Biometric authentication has been disabled."

            let alert = UIAlertController(
                title: "Biometric Authentication",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load saved biometric preference
            biometricSwitch.isOn = UserDefaults.standard.bool(forKey: "biometricEnabled")

        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        navBar.configure(style: .backWithTitle(title: "Biometric Authenication"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    


}
