//
//  DSavedCollectorsViewController.swift
//  DonAte
//
//  Created by Guest 1 on 02/01/2026.
//

import UIKit

class DSavedCollectorsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // Temporary sample data (to be replaced with Firebase later)
        private let collectors: [(name: String, imageName: String)] = [
            ("Kaaf Humanitarian", "KaafLogo"),
            ("Ba9maa", "Ba9maLogo")
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
        
        navBar.configure(style: .backWithTitle(title: "Saved Collectors"))
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
    

extension DSavedCollectorsViewController: UITableViewDataSource, UITableViewDelegate {

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

    


