//
//  VerifyPasswordViewController.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class VerifyPasswordViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private var verifiedEmail: String?
    
    @IBOutlet weak var fNameTextField: UITextField!
    
    @IBOutlet weak var lNameTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        // 1) Read inputs
        let first = (fNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let last  = (lNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let user  = (userNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let phone = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2) Basic validation
        guard !first.isEmpty, !last.isEmpty, !user.isEmpty, !phone.isEmpty else {
            showAlert(title: "Missing Info", message: "Please fill in all fields.")
            return
        }
        
        setLoading(true)
        
        // 3) Look up by username (unique) in Users
        db.collection("Users")
            .whereField("username", isEqualTo: user)
            .limit(to: 1)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                self.setLoading(false)
                
                if let error = error {
                    print("Verify query error:", error.localizedDescription)
                    self.showAlert(title: "Error", message: "Please try again.")
                    return
                }
                
                guard let doc = snapshot?.documents.first else {
                    self.showAlert(title: "Not Found", message: "No account matches that username.")
                    return
                }
                
                // 4) Compare other fields
                let data = doc.data()
                let dbFirst = (data["firstName"] as? String ?? "")
                let dbLast  = (data["lastName"] as? String ?? "")
                let dbPhone = (data["phone"] as? String ?? "")
                let dbEmail = (data["email"] as? String ?? "")
                
                // Make matching a bit forgiving (case-insensitive names)
                let matches =
                dbFirst.caseInsensitiveCompare(first) == .orderedSame &&
                dbLast.caseInsensitiveCompare(last) == .orderedSame &&
                dbPhone == phone &&
                !dbEmail.isEmpty
                
                if matches {
                    // ✅ Verified — pass email to next screen
                    self.verifiedEmail = dbEmail
                    self.performSegue(withIdentifier: "goToNewPassword", sender: self)
                } else {
                    self.showAlert(title: "Verification Failed",
                                   message: "The details you entered do not match our records.")
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewPassword",
           let dest = segue.destination as? NewPasswordViewController {
         //   dest.emailForReset = verifiedEmail
            //do it later 
        }
    }
    
    private func setLoading(_ loading: Bool) {
        submitButton.isEnabled = !loading
        submitButton.alpha = loading ? 0.6 : 1.0
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
