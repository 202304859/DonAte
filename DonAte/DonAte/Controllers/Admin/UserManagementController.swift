//
//  UserManagementController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 23/12/2025.
//

import UIKit

class UserManagementController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum UserManagementMode {
        case all
        case registrationApproval
        case reports
        case activity
    }
    

    private var currentMode: UserManagementMode = .all
    @IBOutlet weak var filter2: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
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
        case "Registeration Approval":
            switchMode(.registrationApproval)
        case "Reports":
            switchMode(.reports)
        case "Activity":
            switchMode(.activity)
        default:
            break
        }
    }
    
    private func loadHeader<T: UIView>(_ nibName: String) -> T {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! T
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

        navBar.configure(style: .titleOnly(title: "User Management"))
        
        // to make 'All' selected by default
        if let firstButton = filterButtons.first {
            filterButtonTapped(firstButton)
        }
        
        tableView.contentInsetAdjustmentBehavior = .never
        
      
    }
    
 
    
    
   
    
    private func switchMode(_ mode: UserManagementMode){
        currentMode = mode
        configureSearchForMode()
        tableView.reloadData()
        
    }
 
    

    
    private func configureSearchForMode() {
        switch currentMode {
        case .registrationApproval:
            searchBar.isHidden = true
            filter2.isHidden = true
        default:
            searchBar.isHidden = false
            filter2.isHidden = false
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }

    /*
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentMode {
            case .all:
                return 5           //Users.count temp
            case .registrationApproval:
                return 5        //pendingApprovals.count
            case .reports:
                return 5          //reports.count
            case .activity:
                return 5        //activities.count
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMode {
        case .all:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            return cell
            
        case .registrationApproval:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCell", for: indexPath)
            return cell
            
        case .reports:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
            return cell
            
        case .activity:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch currentMode {
        case .all:
            return 110

        case .registrationApproval:
            return 220

        case .reports:
            return 188

        case .activity:
            return 120
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
