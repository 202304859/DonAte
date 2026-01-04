//
//  ViewDonorPageViewController.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import UIKit

final class ViewDonorPageViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!

    // Data passed from search screen
    var usernameText: String = ""
    var firstNameText: String = ""
    var lastNameText: String = ""
    var pointsValue: Int = 0
    var avatarName: String = "BoyLogo"

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
        
        navBar.configure(style: .backWithTitle(title: ""))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
           
        }

        profileImageView.image = UIImage(named: avatarName)
        usernameLabel.text = usernameText
        firstNameLabel.text = firstNameText
        lastNameLabel.text = lastNameText
        pointsLabel.text = "\(pointsValue)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
