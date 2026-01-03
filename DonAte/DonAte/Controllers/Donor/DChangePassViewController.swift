//
//  DChangePassViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//
import FirebaseAuth
import UIKit

class DChangePassViewController: UIViewController {
    
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
        @IBOutlet weak var newPasswordTextField: UITextField!
        @IBOutlet weak var confirmNewPasswordTextField: UITextField!

        // MARK: - Actions

        @IBAction func saveButtonType(_ sender: UIButton) {

            // 1) Read + trim inputs
            let oldPass = (oldPasswordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let newPass = (newPasswordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let confirm = (confirmNewPasswordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

            // 2) Validate empty
            guard !oldPass.isEmpty else {
                showAlert(title: "Missing Old Password", message: "Please enter your old password.")
                return
            }

            guard !newPass.isEmpty else {
                showAlert(title: "Missing New Password", message: "Please enter a new password.")
                return
            }

            guard !confirm.isEmpty else {
                showAlert(title: "Missing Confirm Password", message: "Please confirm your new password.")
                return
            }

            // 3) Validate length (exactly 8 characters — as per your project rule)
            guard newPass.count >= 8 else {
                showAlert(title: "Invalid Password", message: "New password must be atleast 8 characters long.")
                return
            }

            // 4) Validate match
            guard newPass == confirm else {
                showAlert(title: "Passwords Don’t Match", message: "New password and confirm password must match.")
                return
            }

            // 5) Get current user + email
            guard let user = Auth.auth().currentUser,
                  let email = user.email else {
                showAlert(title: "Error", message: "No logged-in user found. Please login again.")
                return
            }

            // 6) Re-authenticate using old password (required by Firebase)
            let credential = EmailAuthProvider.credential(withEmail: email, password: oldPass)

            user.reauthenticate(with: credential) { [weak self] _, error in
                guard let self = self else { return }

                if let error = error {
                    self.showAlert(title: "Wrong Old Password", message: error.localizedDescription)
                    return
                }

                // 7) Update password
                user.updatePassword(to: newPass) { error in
                    if let error = error {
                        self.showAlert(title: "Update Failed", message: error.localizedDescription)
                        return
                    }

                    // 8) Success alert → go back
                    let alert = UIAlertController(
                        title: "Success!",
                        message: "Password changed successfully!",
                        preferredStyle: .alert
                    )

                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        // If pushed, pop. If modal, dismiss.
                        if let nav = self.navigationController {
                            nav.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true)
                        }
                    })

                    self.present(alert, animated: true)
                }
            }
        }

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            // 1) Setup your custom header
            let navBar = CustomNavigationBar()
            navBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navBar)

            NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalTo: view.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navBar.heightAnchor.constraint(equalToConstant: 150)
            ])

            navBar.configure(style: .backWithTitle(title: "Change Password"))
            navBar.onBackTapped = { [weak self] in
                // If pushed, pop. If modal, dismiss.
                if let nav = self?.navigationController {
                    nav.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // 2) Hide default navigation bar
            navigationController?.setNavigationBarHidden(true, animated: false)
        }

        // MARK: - Helpers

        private func showAlert(title: String, message: String) {
            // 1) Create alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // 2) Add OK action
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            // 3) Show alert
            present(alert, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller. */
    
