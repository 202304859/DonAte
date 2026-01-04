//
//  EditDonorProfileViewController.swift
//  DonAte
//
//  Created by Guest 1 on 31/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditDonorProfileViewController: UIViewController {

    // Outlets connected to Edit Profile screen
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    // Firestore reference
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeader()
        loadUserProfileAndPrefill()
    }

    // Custom navigation header
    private func setupHeader() {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .titleOnly(title: "Edit Profile"))
        navBar.onBackTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    // Load user data and prefill text fields
    private func loadUserProfileAndPrefill() {
        // Ensure user is logged in
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }

        // Fetch user document
        db.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Load Failed", message: error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else { return }

            // Prefill fields
            self.firstNameTextField.text = data["firstName"] as? String ?? ""
            self.lastNameTextField.text  = data["lastName"] as? String ?? ""

            let username =
                (data["username"] as? String) ??
                (data["userName"] as? String) ??
                (data["UserName"] as? String) ??
                ""

            self.userNameTextField.text = username
            self.emailTextField.text = data["email"] as? String ?? ""

            if let phoneStr = data["phone"] as? String {
                self.phoneNumberTextField.text = phoneStr
            } else if let phoneInt = data["phone"] as? Int {
                self.phoneNumberTextField.text = String(phoneInt)
            } else {
                self.phoneNumberTextField.text = ""
            }
        }
    }

    // Cancel button action
    @IBAction func cancelButtonType(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    // Save button action
    @IBAction func saveButtonType(_ sender: UIButton) {
        // Ensure user is logged in
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }

        // Read and trim input values
        let fName = (firstNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = (lastNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let username = (userNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Validation
        guard !fName.isEmpty else {
            showAlert(title: "Missing First Name", message: "Please enter your first name.")
            return
        }

        guard !lName.isEmpty else {
            showAlert(title: "Missing Last Name", message: "Please enter your last name.")
            return
        }

        guard !username.isEmpty else {
            showAlert(title: "Missing Username", message: "Please enter a username.")
            return
        }

        guard !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }

        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        guard !phoneRaw.isEmpty else {
            showAlert(title: "Missing Phone", message: "Please enter your phone number.")
            return
        }

        guard isValidPhone8Digits(phoneRaw) else {
            showAlert(title: "Invalid Phone Number", message: "Phone number must be exactly 8 digits.")
            return
        }

        let phone = phoneRaw.filter { $0.isNumber }

        // Prepare updated data
        let updatedData: [String: Any] = [
            "firstName": fName,
            "lastName": lName,
            "username": username,
            "email": email,
            "phone": phone
        ]

        // Update Firestore
        db.collection("Users").document(uid).setData(updatedData, merge: true) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Save Failed", message: error.localizedDescription)
                return
            }

            // Success alert
            let alert = UIAlertController(
                title: "Success!",
                message: "Profile edited successfully",
                preferredStyle: .alert
            )

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }

            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }

    // Simple alert helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Email validation helper
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    // Phone validation helper (Bahrain style)
    private func isValidPhone8Digits(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }
        return digitsOnly.count == 8
    }
}
