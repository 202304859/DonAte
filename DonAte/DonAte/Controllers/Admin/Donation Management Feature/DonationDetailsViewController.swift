//
//  DonationDetailsViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class DonationDetailsViewController: UIViewController {

    @IBAction func ApprovaslTapped(_ sender: UIButton) {
        showSuccessAlert()
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
        
        navBar.configure(style: .backWithTitle(title: "Donation Management"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success!",
            message: "The donation’s approval has been sent to the donor",
            preferredStyle: .alert
        )

        let close = UIAlertAction(title: "Close", style: .cancel){ _ in
            self.dismiss(animated: true)}
        close.setValue(UIColor.lightGray, forKey: "titleTextColor")

        alert.addAction(close)
        present(alert, animated: true)
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


