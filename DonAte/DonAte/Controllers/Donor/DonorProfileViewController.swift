//
//  DonorProfileViewController.swift
//  DonAte
//
//  Created by Guest 1 on 30/12/2025.
//

import UIKit

class DonorProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    
    let items: [ProfileItem] = [
        .init(title: "Impact summary",   iconName: "impactIcon",   storyboardID: "ImpactSB"),
]

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
            
            navBar.configure(style: .titleOnly(title: "Donor Profile"))
            navBar.onBackTapped = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                
                
                
                
                
                // Do any additional setup after loading the view.
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    struct ProfileItem {
        let title: String
        let iconName: String
        let storyboardID: String
    }
    
    


}
extension DonorProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)

        cell.textLabel?.text = item.title
        cell.imageView?.image = UIImage(named: item.iconName)
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = items[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: item.storyboardID) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

