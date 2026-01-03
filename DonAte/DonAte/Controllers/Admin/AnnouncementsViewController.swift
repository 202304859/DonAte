//
//  AnnouncementsViewController.swift
//  DonAte
//
//  Created by BP-36-201-01 on 03/01/2026.
//

import UIKit

class AnnouncementsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
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
        
        navBar.configure(style: .backWithTitle(title: "Announcement"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // temp
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath)
            return cell
        
        }
    
    func tableView(_ tableView: UITableView,
                    heightForRowAt indexPath: IndexPath) -> CGFloat {

             return 150
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
