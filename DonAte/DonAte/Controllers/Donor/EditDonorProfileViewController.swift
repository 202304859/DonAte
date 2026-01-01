//
//  EditDonorProfileViewController.swift
//  DonAte
//
//  Created by Guest 1 on 31/12/2025.
//

import UIKit

class EditDonorProfileViewController: UIViewController {
    
    //this is for adding shadow to the button. Just an extra effect.
    /*@IBOutlet weak var Button: UIButton!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        Button.layer.cornerRadius = Button.bounds.height / 2
        Button.updateCleanShadowPath()
    }*/
    
    
    
    @IBAction func saveButtonType(_ sender: UIButton) {
        // 1. Create alert
            let alert = UIAlertController(
                title: "Success!",
                message: "Profile edited successfully",
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
        
   //     Button.layer.cornerRadius = Button.bounds.height / 2
    //    Button.applyBottomRightShadow()
        
        
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
