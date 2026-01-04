//
//  LoginViewController.swift
//  DonAte
//
//  Created by BP-36-201-05 on 10/12/2025.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let biometricKey = "biometricEnabled"
    private var didAttemptAutoUnlock = false

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

        navBar.configure(style: .donate)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        didAttemptAutoUnlock = false

        // Default: show login fields
        setLoginUI(enabled: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Only try once per screen appearance
        guard !didAttemptAutoUnlock else { return }
        didAttemptAutoUnlock = true

        // If biometrics OFF -> normal login
        guard isBiometricsEnabled() else { return }

        // If user already logged in before on this device, we can skip typing credentials
        guard Auth.auth().currentUser != nil else {
            // No previous session saved by Firebase -> user must login manually once
            return
        }

        // Lock UI while Face ID prompt is happening
        setLoginUI(enabled: false)

        authenticateWithBiometrics { [weak self] success in
            guard let self = self else { return }

            if success {
                // Face ID matched -> go straight to dashboard
                self.navigateToDonorDashboard()
            } else {
                // Face ID failed/cancelled -> allow manual login
                self.setLoginUI(enabled: true)
            }
        }
    }

    // MARK: - Login Button
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        // If user is manually logging in, we do normal Firebase login
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            if let userID = authResult?.user.uid {
                UserDefaults.standard.set(userID, forKey: UserDefaultsKeys.userID)
            }

            // After first successful login, next time Face ID can skip typing
            self.navigateToDonorDashboard()
        }
    }

    // MARK: - Biometrics
    private func isBiometricsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: biometricKey)
    }

    private func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false)
            return
        }

        let reason = "Use Face ID / Touch ID to unlock your account."
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // MARK: - Navigation
    private func navigateToDonorDashboard() {
        let storyboard = UIStoryboard(name: "DonorDashboard", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "donor_tab") as! DonorTabBarController
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }

    // MARK: - UI Helpers
    private func setLoginUI(enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled

        // Optional: clear password if Face ID failed
        if enabled {
            passwordTextField.text = ""
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
