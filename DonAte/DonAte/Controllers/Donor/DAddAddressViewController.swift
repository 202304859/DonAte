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

    

    private let towns = [
        "A'ali",
        "Adliya",
        "Al Hidd",
        "Al Sayh",
        "Askar",
        "Awali",
        "Barbar",
        "Budaiya",
        "Busaiteen",
        "Durrat Al Bahrain",
        "Galali",
        "Hajiyat",
        "Hamad Town",
        "Hamala",
        "Isa Town",
        "Janabiya",
        "Juffair",
        "Karazakan",
        "Malkiya",
        "Manama",
        "Muharraq",
        "Riffa",
        "Sadad",
        "Salman City",
        "Salmabad",
        "Sanabis",
        "Sanad",
        "Saar",
        "Sitra",
        "Tubli",
        "Zallaq",
        "Zinj"
    ]

    private let townPicker = UIPickerView()

    @objc private func donePickingTown() {
        // 1) Close the picker
        townCityTextField.resignFirstResponder()
    }

    

    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var townCityTextField: UITextField!
    @IBOutlet weak var houseNotextField: UITextField!
    @IBOutlet weak var roadNoTextField: UITextField!
    @IBOutlet weak var blockNoTextField: UITextField!

    

    private let db = Firestore.firestore()

    

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

        navBar.configure(style: .backWithTitle(title: "Add Address"))
        navBar.onBackTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        

        // 1) Set picker delegate + data source
        townPicker.delegate = self
        townPicker.dataSource = self
        townCityTextField.delegate = self

        // 2) Use picker as the keyboard for the town/city text field
        townCityTextField.inputView = townPicker

        // 3) Add toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePickingTown))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([space, done], animated: false)
        townCityTextField.inputAccessoryView = toolbar
    }

    // MARK: - Actions

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

        // 4) Create the new address map
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

                // 6) Show success then dismiss
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

    

    // ensure exactly 8 digits
    private func isValidPhone8Digits(_ phone: String) -> Bool {
        // 1) Keep digits only
        let digitsOnly = phone.filter { $0.isNumber }

        // 2) Ensure exactly 8 digits
        return digitsOnly.count == 8
    }

    // quick alert
    private func showAlert(title: String, message: String) {
        // 1) Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // 2) Add OK action
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // 3) Present alert
        present(alert, animated: true)
    }
}


extension DAddAddressViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 1) One column of towns
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 2) Number of towns
        return towns.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 3) Town name at that row
        return towns[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 4) Put selected town into the text field
        townCityTextField.text = towns[row]
    }
}


extension DAddAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1) Prevent typing in Town/City field (picker only)
        if textField == townCityTextField { return false }
        return true
    }
}
