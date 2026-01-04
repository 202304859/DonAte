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

    // MARK: - Stored State
    private var isBiometricEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: biometricKey) }
        set { UserDefaults.standard.set(newValue, forKey: biometricKey) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // --- Custom Nav Bar ---
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .backWithTitle(title: "Biometric Authentication"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        // --- Table setup ---
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Switch Handler
    @objc private func switchChanged(_ sender: UISwitch) {

        // User is turning ON biometrics
        if sender.isOn {
            authenticateBiometrics { [weak self] success in
                guard let self = self else { return }

                if success {
                    // Authentication passed
                    self.isBiometricEnabled = true
                    self.showAlert(
                        title: "Biometric Authentication",
                        message: "Biometric authentication has been enabled."
                    )
                } else {
                    // Failed or cancelled → revert switch
                    sender.setOn(false, animated: true)
                    self.isBiometricEnabled = false
                }
            }
        } else {
            // User turned OFF biometrics
            isBiometricEnabled = false
            showAlert(
                title: "Biometric Authentication",
                message: "Biometric authentication has been disabled."
            )
        }
    }

    // MARK: - Biometric Auth
    private func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check availability
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlert(
                title: "Biometric Authentication",
                message: "Biometric authentication is not available on this device."
            )
            completion(false)
            return
        }

        let reason = "Enable biometric authentication for faster login."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // MARK: - Alert Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView
extension DBioAuthViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BiometricSwitchCell",
            for: indexPath
        )

        cell.selectionStyle = .none
        cell.textLabel?.text = "Biometric Authentication"

        let toggle = UISwitch()
        toggle.isOn = isBiometricEnabled
        toggle.addTarget(self,
                         action: #selector(switchChanged(_:)),
                         for: .valueChanged)

        cell.accessoryView = toggle
        return cell
    }
}
