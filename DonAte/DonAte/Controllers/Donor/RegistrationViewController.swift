//
//  RegistrationViewController.swift
//  DonAte
//
//  Created by Guest 1 on 29/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var fNameTextField: UITextField!
    
    @IBOutlet weak var lNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // 1) Read and trim inputs
            let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let password = (passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let fName = (fNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = (lNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

            // 2) Validate empty fields
            guard !email.isEmpty else {
                showAlert(title: "Missing Email", message: "Please enter your email address.")
                return
            }

            guard isValidEmail(email) else {
                showAlert(title: "Invalid Email", message: "Please enter a valid email address (example: name@email.com).")
                return
            }

            guard !password.isEmpty else {
                showAlert(title: "Missing Password", message: "Please enter your password.")
                return
            }
        
        guard password.count >= 8 else{
            showAlert(title: "Invalid Password", message: "Password has to be atleast 8 characters long.")
            return
        }

            // 3) Validate phone (exactly 8 digits)
            guard !phoneRaw.isEmpty else {
                showAlert(title: "Missing Phone", message: "Please enter your phone number.")
                return
            }

            guard isValidPhone8Digits(phoneRaw) else {
                showAlert(title: "Invalid Phone Number", message: "Phone number must be exactly 8 digits.")
                return
            }
        guard !fName.isEmpty else {
            showAlert(title: "Missing First Name", message: "Please enter your first name.")
            return
        }
        guard !lName.isEmpty else {
            showAlert(title: "Missing Last Name", message: "Please enter your last name.")
            return
        }

            // 4) Convert phone to digits only (in case user typed spaces)
            let phone = phoneRaw.filter { $0.isNumber }

            // 5) Create user in Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }

                // 6) Handle auth error
                if let error = error {
                    self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                    return
                }

                // 7) Get UID of the new user
                guard let uid = result?.user.uid else {
                    self.showAlert(title: "Error", message: "Could not create user. Please try again.")
                    return
                }

                // 8) Create user document in Firestore
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "email": email,
                    "phone": phone,
                    "createdAt": Timestamp(),
                    "address": []
                ]

                db.collection("Users").document(uid).setData(userData) { error in
                    if let error = error {
                        self.showAlert(title: "Database Error", message: "Account created, but failed to save profile data.\n\(error.localizedDescription)")
                        return
                    }

                    // 9) Success alert (then navigate where you want)
                    let alert = UIAlertController(title: "Success!", message: "Your account has been created.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        // 10) Move to your dashboard / tab bar
                        self.goToAddressPage()
                    })
                    self.present(alert, animated: true)
                }
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
    

    
    // 1) Simple email validation using regex
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    // 2) Phone must be exactly 8 digits
    private func isValidPhone8Digits(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }          // keep only numbers
        return digitsOnly.count == 8 && digitsOnly.allSatisfy { $0.isNumber }
    }

    private func goToAddressPage() {

        // 1) Get the current storyboard
        guard let storyboard = self.storyboard else { return }

        // 2) Instantiate Address View Controller
        let addressVC = storyboard.instantiateViewController(
            withIdentifier: "NewDonorAddressViewController"
        ) as! NewDonorAddressViewController

        // 3) Present modally (full screen)
        addressVC.modalPresentationStyle = .fullScreen
        present(addressVC, animated: false)
    }


}
