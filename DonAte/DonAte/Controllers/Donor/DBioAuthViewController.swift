//
//  DBioAuthViewController.swift
//  DonAte
//
//  Created by Guest 1 on 02/01/2026.
//

import UIKit
import LocalAuthentication

class DBioAuthViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private let biometricKey = "biometricEnabled"

        // MARK: - State
        private var isBiometricEnabled: Bool {
            // 1) Read saved value (default is false)
            get { UserDefaults.standard.bool(forKey: biometricKey) }
            // 2) Save value
            set { UserDefaults.standard.set(newValue, forKey: biometricKey) }
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
        
        navBar.configure(style: .backWithTitle(title: "Biometric Authenication"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
           
        }
        
        //Table view setup
                tableView.dataSource = self
                tableView.delegate = self
                tableView.isScrollEnabled = false
                tableView.separatorInset = .zero

                //Make the table look clean
                tableView.tableFooterView = UIView()
    }
    
    // MARK: - Switch change handler
        @objc private func switchChanged(_ sender: UISwitch) {

            // 6) If user turns it ON, confirm device supports biometrics
            if sender.isOn {
                let context = LAContext()
                var error: NSError?

                // 7) Check if biometrics are available (Face ID / Touch ID)
                let canUse = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

                if canUse {
                    // 8) Save ON state
                    isBiometricEnabled = true

                    // 9) Show success alert
                    showAlert(title: "Biometric Authentication",
                              message: "Biometric authentication has been enabled.")
                } else {
                    // 10) Revert switch OFF (since biometrics unavailable)
                    sender.setOn(false, animated: true)
                    isBiometricEnabled = false

                    // 11) Show info alert
                    showAlert(title: "Biometric Authentication",
                              message: "Biometric authentication is not available on this device.")
                }
            } else {
                // 12) User turned it OFF -> save OFF state
                isBiometricEnabled = false

                // 13) Show disabled alert
                showAlert(title: "Biometric Authentication",
                          message: "Biometric authentication has been disabled.")
            }
        }

        // MARK: - Alert helper
        private func showAlert(title: String, message: String) {
            // 14) Create alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // 15) Add OK button
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            // 16) Present alert
            present(alert, animated: true)
        }
    }


    // MARK: - UITableViewDataSource + UITableViewDelegate
extension DBioAuthViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 17) Only one row
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 18) Dequeue your prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BiometricSwitchCell", for: indexPath)
        
        // 19) Settings look
        cell.selectionStyle = .none
        cell.textLabel?.text = "Biometric Authentication"
        
        // 20) Create the switch and set saved state
        let toggle = UISwitch()
        toggle.isOn = isBiometricEnabled
        
        // 21) Connect switch action
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        // 22) Put switch on the right side
        cell.accessoryView = toggle
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
}
