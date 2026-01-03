//
//  RegistrationViewController.swift
//  DonAte
//
//  Created by Guest 1 on 29/12/2025.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var fNameTextField: UITextField!
    
    @IBOutlet weak var lNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firstName = fNameTextField.text,
        !firstName.isEmpty else {
        showAlert(title: "Missing First Name", message: "Please enter your first name.")
        return
        }
        guard let lastName = lNameTextField.text,
        !lastName.isEmpty else {
        showAlert(title: "Missing last Name", message: "Please enter your last name.")
        return
        }
        guard let phoneNumber = phoneNumberTextField.text,
        !phoneNumber.isEmpty else {
        showAlert(title: "Missing Phone Number", message: "Please enter your phone number.")
        return
        }
        guard let email = emailTextField.text, !email.isEmpty
        else {
        showAlert(title: "Missing Email", message: "Please enter an email address.")
        return
        }
        guard let password = passwordTextField.text,
        !password.isEmpty else {
        showAlert(title: "Missing Password", message: "Please enter a password.")
        return
        }
        guard let confirmPassword = confirmPasswordTextField.text,
        !confirmPassword.isEmpty else {
        showAlert(title: "Missing Confirmation", message:
        "Please confirm your password.")
        return
        }
        // Validate password match
        guard password == confirmPassword else {
        showAlert(title: "Password Mismatch", message:
        "Passwords do not match. Please try again.")
        return
        }
        // Validate password length
        guard password.count >= 8 else {
        showAlert(title: "Weak Password", message: "Password must be at least 8 characters long.")
        return
        }
        // Create user account with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password:
        password) { [weak self] authResult, error in
        if let error = error {
        // Registration failed - show error message
        self?.showAlert(title: "Registration Failed",
        message: error.localizedDescription)
        return
        }
        // Registration successful
        self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message:
    message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style:
    .default))
    present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
 

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
