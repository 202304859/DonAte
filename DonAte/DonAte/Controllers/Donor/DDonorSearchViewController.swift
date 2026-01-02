//
//  DDonorSearchViewController.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import UIKit

class DDonorSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    

    // Temporary sample data (to be replaced with Firebase later)
        private let collectors: [(name: String, imageName: String)] = [
            ("Aysha_124", "AyshaLogo"),
            ("Chef.01", "ChefLogo")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Match the card UI style
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        // Give cells a visible height
        tableView.rowHeight = 120
        
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        navBar.configure(style: .titleOnly(title: "Search"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            
        }
        
    }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }


override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
}

}

extension DDonorSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1) Tell table view how many collectors to show
        return collectors.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 2) Dequeue your custom card cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCollectorCell",
                                                 for: indexPath) as! SavedCollectorCell

        // 3) Get data for this row
        let item = collectors[indexPath.row]

        // 4) Load image from Assets (same name as in imageName)
        let img = UIImage(named: item.imageName)

        // 5) Fill the cell UI
        cell.configure(name: item.name, image: img)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Optional: handle tapping a collector
        tableView.deselectRow(at: indexPath, animated: true)

        // Example: print which one was tapped
        print("Tapped:", collectors[indexPath.row].name)

        //navigate to collector details under this
    }
}

