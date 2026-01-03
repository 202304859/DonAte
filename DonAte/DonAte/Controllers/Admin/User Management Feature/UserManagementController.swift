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
    
    
    @IBAction func DissmissInfoTapped(_ sender: Any) {
        showDismissAlert()
    }
    
    @IBAction func reguestInfoTapped(_ sender: Any) {
        showRequestInfoAlert()
    }
    @IBAction func sendTapped(_ sender: UIButton) {
        showApprovalAlert()
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
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleRejection),
                name: .applicationRejected,
                object: nil
            )
        
      
    }
    
    
    
    @objc private func handleRejection() {
        // Remove item from data source
        // TODO: remove rejected items later when we addd models
        // Update table
        tableView.reloadData()
    }
    
    
    private func showRequestInfoAlert() {
        let alert = UIAlertController(
            title: "Request Information",
            message: "Do you want to request additional information from this user?",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIColor.gray, forKey: "titleTextColor")
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.handleRequestInfo()
        }
        confirm.setValue(UIColor.color1, forKey: "titleTextColor")

        alert.addAction(cancel)
        alert.addAction(confirm)

        present(alert, animated: true)
    }
    
    private func handleRequestInfo() {
        let storyboard = UIStoryboard(name: "UserManagement", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "RequestInfoViewController"
        )

        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    

    private func switchMode(_ mode: UserManagementMode){
        currentMode = mode
        configureSearchForMode()
        tableView.reloadData()
        
    }
    
    private func showApprovalAlert() {
        let alert = UIAlertController(
            title: "Success!",
            message: "BahrainiYouthKitchen has been approved.", // TODO: for now a placeholder
            preferredStyle: .alert
        )

        let close = UIAlertAction(title: "Close", style: .cancel)
        close.setValue(UIColor.lightGray, forKey: "titleTextColor")

        alert.addAction(close)
        present(alert, animated: true)
    }
    
    private func showDismissAlert() {
        let alert = UIAlertController(
            title: "Dismissal Confirmation",
            message: "Are you sure you want to dismiss this report?",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIColor.gray, forKey: "titleTextColor")
        let confirm = UIAlertAction(title: "Confirm", style: .default)
        
        confirm.setValue(UIColor.color1, forKey: "titleTextColor")

        alert.addAction(cancel)
        alert.addAction(confirm)

        present(alert, animated: true)
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
    
    
    // to remove the default back
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
