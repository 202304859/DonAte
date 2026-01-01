//
//  DonorAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class DonorAddressViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let sample = [ //sample just to see the design, will connect to firebase later
           ("Home", "1234, 776, 4987, Manama,\n+937 32345678"),
           ("Office", "789, 196, 9587, Adliya,\n+937 32345678")
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

            
            tableView.dataSource = self
            tableView.delegate = self

            
            tableView.reloadData()
        
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        navBar.configure(style: .backWithTitle(title: "Donor Addresses"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            
            
            
        }
        
        // Connect the table view to this controller
                tableView.dataSource = self
                tableView.delegate = self
        
        //this is to set height for the table view because it wasnt showing at the beginning
       // tableView.rowHeight = UITableView.automaticDimension
        //    tableView.estimatedRowHeight = 140
        //tableView.rowHeight = 140 (this was just to test temporarily)

                // Make it match your UI (no separators, clear background)
                tableView.separatorStyle = .none
                tableView.backgroundColor = .clear
        
         }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    

        
    }

extension DonorAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("✅ numberOfRows called") //mainly for debugging purposes
        // Tell the table view how many rows to show
        return sample.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("✅ cellForRow called at row \(indexPath.row)")  //mainly for debugging purposes

            
       let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCardCell",
                                                for: indexPath) as! AddressCardCell
        
        // Fill the cell with sample text
      let item = sample[indexPath.row]
       cell.configure(title: item.0, details: item.1)
      //
      return cell
    }
    
}
