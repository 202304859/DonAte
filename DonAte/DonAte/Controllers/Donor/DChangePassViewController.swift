//
//  DChangePassViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class DChangePassViewController: UIViewController {
    
    
    @IBAction func cancelButtonType(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func saveButtonType(_ sender: UIButton) {
     
        // 1. Create alert
            let alert = UIAlertController(
                title: "Success!",
                message: "Password changed successfully!",
                preferredStyle: .alert)
        
        // 2. OK action
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Navigate back to Profile page
                self.navigationController?.popViewController(animated: true)
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
        
        navBar.configure(style: .backWithTitle(title: "Change Password"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    //this is to remove the automatically added back button.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller. */
    
