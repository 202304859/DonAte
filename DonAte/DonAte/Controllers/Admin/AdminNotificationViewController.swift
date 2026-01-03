//
//  AdminNotificationViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class AdminNotificationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var filterButtons: [UIButton]!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        for button in filterButtons {
            var config = button.configuration
            // when the button is not selected
            button.isSelected = false
            config?.background.backgroundColor = .color4
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            button.configuration = config
        }
        
        var selectedConfig = sender.configuration
        sender.isSelected = true
        selectedConfig?.background.backgroundColor = .color5
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        sender.configuration = selectedConfig
    }
    
    
    override func viewDidLoad() {
        
        if let firstButton = filterButtons.first {
            filterButtonTapped(firstButton)
        }
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

        navBar.configure(style: .titleOnly(title: "Notifications"))
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // temp
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
            return cell
        
        }
    
    func tableView(_ tableView: UITableView,
                    heightForRowAt indexPath: IndexPath) -> CGFloat {

             return 100
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
