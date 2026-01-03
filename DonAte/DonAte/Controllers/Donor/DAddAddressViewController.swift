//
//  DAddAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DAddAddressViewController: UIViewController {

    // Connect these outlets to your Add Address screen UI
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var townCityTextField: UITextField!
    @IBOutlet weak var houseNotextField: UITextField!
    @IBOutlet weak var roadNoTextField: UITextField!
    @IBOutlet weak var blockNoTextField: UITextField!

    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep your header code (same as your current file) :contentReference[oaicite:2]{index=2}
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .backWithTitle(title: "Add Address"))
        navBar.onBackTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @IBAction func saveButtonType(_ sender: UIButton) {
        // 1) Make sure user is logged in
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }

        // 2) Read and clean inputs
        let addressName = (addressNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let townCity = (townCityTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let houseNo = (houseNotextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let roadNo = (roadNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let blockNo = (blockNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // 3) Basic validation
        guard !addressName.isEmpty else {
            showAlert(title: "Missing Address Name", message: "Please enter an address name (e.g., Home).")
            return
        }

        guard !phoneRaw.isEmpty else {
            showAlert(title: "Missing Phone", message: "Please enter a phone number.")
            return
        }

        guard isValidPhone8Digits(phoneRaw) else {
            showAlert(title: "Invalid Phone", message: "Phone number must be exactly 8 digits.")
            return
        }

        guard !townCity.isEmpty else {
            showAlert(title: "Missing Town/City", message: "Please enter your town/city.")
            return
        }

        guard !houseNo.isEmpty, !roadNo.isEmpty, !blockNo.isEmpty else {
            showAlert(title: "Missing Fields", message: "Please fill house, road, and block numbers.")
            return
        }

        // 4) Create the new address map (same structure as your Firestore screenshot)
        let addressId = "addr_" + UUID().uuidString.prefix(8)

        let phoneDigits = phoneRaw.filter { $0.isNumber }

        let newAddress: [String: Any] = [
            "addressId": String(addressId),
            "addressName": addressName,
            "addressPhone": Int(phoneDigits) ?? 0,
            "townCity": townCity,
            "houseNo": Int(houseNo) ?? 0,
            "roadNo": Int(roadNo) ?? 0,
            "blockNo": Int(blockNo) ?? 0
        ]

        // 5) Read-modify-write: append new address into Users/{uid}.address
        let userDoc = db.collection("Users").document(uid)

        userDoc.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Save Failed", message: error.localizedDescription)
                return
            }

            // If "address" doesn't exist yet, start with an empty array
            var raw = snapshot?.data()?["address"] as? [[String: Any]] ?? []
            raw.append(newAddress)

            userDoc.updateData(["address": raw]) { err in
                if let err = err {
                    self.showAlert(title: "Save Failed", message: err.localizedDescription)
                    return
                }

                // 6) Show success then dismiss (same behavior as your current file) :contentReference[oaicite:3]{index=3}
                let alert = UIAlertController(
                    title: "Success!",
                    message: "Address added successfully!",
                    preferredStyle: .alert
                )

                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true)
                }

                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }

    // Helper: ensure exactly 8 digits (Bahrain style)
    private func isValidPhone8Digits(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }
        return digitsOnly.count == 8
    }

    // Helper: quick alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
