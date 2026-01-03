//
//  DonationsManagement2ViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class DonationsManagement2ViewController: UIViewController, UITableViewDataSource,
                                          UITableViewDelegate {
    
    enum donationManagementMode {
        case all
        case pendingApproval
        
    }
    
    private var currentMode: donationManagementMode = .all
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
        
        switch sender.configuration?.title{
            case "All":
            switchMode(.all)
        case "Pending Approval":
            switchMode(.pendingApproval)
        default:
            break
        }
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
            
            // to make 'All' selected by default
            if let firstButton = filterButtons.last {
                filterButtonTapped(firstButton)
            }
            
            tableView.contentInsetAdjustmentBehavior = .never
            
            tableView.dataSource = self
            tableView.delegate = self
            
            
        }
    
    private func switchMode(_ mode: donationManagementMode){
        currentMode = mode
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentMode {
            case .all:
                return 5           //Users.count temp
        case .pendingApproval:
                return 5        //pendingApprovals.count
            }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMode {
        case .all:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath)
            return cell
            
        case .pendingApproval:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCell", for: indexPath)
            return cell
       
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch currentMode {
        case .all:
            return 160

        case .pendingApproval:
            return 160
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
        
    }

