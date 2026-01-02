//
//  DAddAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class DAddAddressViewController: UIViewController {
    
    
    @IBAction func saveButtonType(_ sender: UIButton) {
        // 1. Create alert
            let alert = UIAlertController(
                title: "Success!",
                message: "Address added successfully!",
                preferredStyle: .alert)
        
        // 2. OK action
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Navigate back to Profile page
                self.dismiss(animated: true)
            }
        
        // 3. Add action & show alert
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    
    
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
        
        navBar.configure(style: .backWithTitle(title: "Add Address"))
        navBar.onBackTapped = { [weak self] in
            // Close the modal screen and return to the previous screen
            self?.dismiss(animated: true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller. */
    }
    

}
