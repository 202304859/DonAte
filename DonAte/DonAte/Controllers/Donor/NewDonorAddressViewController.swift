//
//  NewDonorAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewDonorAddressViewController: UIViewController {
    
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
    
    @IBOutlet weak var addressNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var townCityTextField: UITextField!
    
    @IBOutlet weak var houseNotextField: UITextField!
    
    @IBOutlet weak var roadNoTextField: UITextField!
    
    @IBOutlet weak var blockNoTextField: UITextField!
    
    @objc private func donePickingTown() {
        // 1) Close the picker
        townCityTextField.resignFirstResponder()
    }

    
    @IBAction func registerButtonTapped(_ sender: UIButton) {

        // 1) Make sure user is logged in
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "You are not logged in. Please login again.")
            return
        }

        // 2) Read and trim inputs
        let addressName = (addressNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let townCity = (townCityTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let houseNo = (houseNotextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let roadNo = (roadNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let blockNo = (blockNoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // 3) Validate required fields (adjust if some are optional)
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

        guard !houseNo.isEmpty else {
            showAlert(title: "Missing House/Flat No.", message: "Please enter house/flat number.")
            return
        }

        guard !roadNo.isEmpty else {
            showAlert(title: "Missing Road No.", message: "Please enter road number.")
            return
        }

        guard !blockNo.isEmpty else {
            showAlert(title: "Missing Block No.", message: "Please enter block number.")
            return
        }

        // 4) Clean phone to digits only
        let phone = phoneRaw.filter { $0.isNumber }

        // 5) Create an address dictionary (matches your Firestore keys)
        let addressId = UUID().uuidString  // unique id for this address

        let newAddress: [String: Any] = [
            "addressId": addressId,
            "addressName": addressName,
            "addressPhone": Int(phone) ?? 0,
            "townCity": townCity,
            "houseNo": Int(houseNo) ?? 0,
            "roadNo": Int(roadNo) ?? 0,
            "blockNo": Int(blockNo) ?? 0
        ]

        // 6) Save using arrayUnion (adds to the address array)
        let db = Firestore.firestore()
        db.collection("Users").document(uid).updateData([
            "address": FieldValue.arrayUnion([newAddress])
        ]) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Save Failed", message: error.localizedDescription)
                return
            }

            // 7) Success message then go to dashboard
            let alert = UIAlertController(title: "Success!",
                                          message: "Address saved successfully.",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigateToDonorDashboard()
            })

            self.present(alert, animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    private func navigateToDonorDashboard() {

        // 1) Load DonorDashboard storyboard
        let storyboard = UIStoryboard(name: "DonorDashboard", bundle: nil)

        // 2) Instantiate the Tab Bar Controller
        let tabBar = storyboard.instantiateViewController(
            withIdentifier: "donor_tab"
        ) as! DonorTabBarController

        // 3) Present full screen
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
    
    private func isValidPhone8Digits(_ phone: String) -> Bool {
        // 1) Keep digits only
        let digitsOnly = phone.filter { $0.isNumber }

        // 2) Ensure exactly 8 digits
        return digitsOnly.count == 8
    }

    private func showAlert(title: String, message: String) {
        // 1) Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // 2) Add OK action
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // 3) Present alert
        present(alert, animated: true)
    }

    
}

extension NewDonorAddressViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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

extension NewDonorAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1) Prevent typing in Town/City field (picker only)
        if textField == townCityTextField { return false }
        return true
    }
}


