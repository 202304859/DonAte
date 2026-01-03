//
//  DEditAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DEditAddressViewController: UIViewController {

    // Connect these outlets to your Edit Address screen UI
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var townCityTextField: UITextField!
    @IBOutlet weak var houseNotextField: UITextField!
    @IBOutlet weak var roadNoTextField: UITextField!
    @IBOutlet weak var blockNoTextField: UITextField!

    // This gets set by DonorAddressViewController before navigation
    var addressToEdit: DonorAddress?

    private let db = Firestore.firestore()

    // Same towns + picker style as your Add Address screen :contentReference[oaicite:2]{index=2}
    private let towns = [
        "A'ali","Adliya","Al Hidd","Al Sayh","Askar","Awali","Barbar","Budaiya","Busaiteen",
        "Durrat Al Bahrain","Galali","Hajiyat","Hamad Town","Hamala","Isa Town","Janabiya",
        "Juffair","Karazakan","Malkiya","Manama","Muharraq","Riffa","Sadad","Salman City",
        "Salmabad","Sanabis","Sanad","Saar","Sitra","Tubli","Zallaq","Zinj"
    ]

    private let townPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep your header code (do not remove) :contentReference[oaicite:3]{index=3}
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .backWithTitle(title: "Edit Address"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        // Picker setup (same manner as Add Address) :contentReference[oaicite:4]{index=4}
        townPicker.delegate = self
        townPicker.dataSource = self
        townCityTextField.delegate = self
        townCityTextField.inputView = townPicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePickingTown))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, done], animated: false)
        townCityTextField.inputAccessoryView = toolbar

        // Prefill textfields
        fillFields()
    }

    private func fillFields() {
        guard let a = addressToEdit else { return }

        addressNameTextField.text = a.addressName
        phoneNumberTextField.text = a.addressPhone
        townCityTextField.text = a.townCity
        houseNotextField.text = a.houseNo
        roadNoTextField.text = a.roadNo
        blockNoTextField.text = a.blockNo

        // If town exists in picker list, select it
        if let idx = towns.firstIndex(of: a.townCity) {
            townPicker.selectRow(idx, inComponent: 0, animated: false)
        }
    }

    @objc private func donePickingTown() {
        townCityTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }
        guard let original = addressToEdit else {
            showAlert(title: "Error", message: "No address selected to edit.")
            return
        }

        // Read and trim inputs
        let addressName = (addressNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let townCity = (townCityTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let houseNo = (houseNotextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let roadNo = (roadNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let blockNo = (blockNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Validations (same style as Add Address) :contentReference[oaicite:5]{index=5}
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

        let phoneDigits = phoneRaw.filter { $0.isNumber }

        // New updated dictionary (keep same addressId)
        let updatedAddress: [String: Any] = [
            "addressId": original.addressId,
            "addressName": addressName,
            "addressPhone": Int(phoneDigits) ?? 0,
            "townCity": townCity,
            "houseNo": Int(houseNo) ?? 0,
            "roadNo": Int(roadNo) ?? 0,
            "blockNo": Int(blockNo) ?? 0
        ]

        // Read-modify-write the address array
        db.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Save Failed", message: error.localizedDescription)
                return
            }

            guard let data = snapshot?.data(),
                  var raw = data["address"] as? [[String: Any]] else {
                self.showAlert(title: "Save Failed", message: "Could not read saved addresses.")
                return
            }

            // Find the address by addressId and replace it
            if let index = raw.firstIndex(where: { ($0["addressId"] as? String) == original.addressId }) {
                raw[index] = updatedAddress
            } else {
                self.showAlert(title: "Save Failed", message: "Address not found to update.")
                return
            }

            self.db.collection("Users").document(uid).updateData(["address": raw]) { err in
                if let err = err {
                    self.showAlert(title: "Save Failed", message: err.localizedDescription)
                    return
                }

                // Go back; saved addresses screen will refresh in viewWillAppear
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }
        guard let original = addressToEdit else {
            showAlert(title: "Error", message: "No address selected to delete.")
            return
        }

        // Confirm delete
        let alert = UIAlertController(title: "Delete Address",
                                      message: "Are you sure you want to delete this address?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }

            self.db.collection("Users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    self.showAlert(title: "Delete Failed", message: error.localizedDescription)
                    return
                }

                guard let data = snapshot?.data(),
                      var raw = data["address"] as? [[String: Any]] else {
                    self.showAlert(title: "Delete Failed", message: "Could not read saved addresses.")
                    return
                }

                // Remove by addressId
                raw.removeAll { ($0["addressId"] as? String) == original.addressId }

                self.db.collection("Users").document(uid).updateData(["address": raw]) { err in
                    if let err = err {
                        self.showAlert(title: "Delete Failed", message: err.localizedDescription)
                        return
                    }

                    // Go back; saved addresses screen will refresh in viewWillAppear
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })

        present(alert, animated: true)
    }

    private func isValidPhone8Digits(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }
        return digitsOnly.count == 8
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Picker + TextField
extension DEditAddressViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { towns.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { towns[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        townCityTextField.text = towns[row]
    }
}

extension DEditAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Prevent typing in Town/City field (picker only) :contentReference[oaicite:6]{index=6}
        if textField == townCityTextField { return false }
        return true
    }
}
