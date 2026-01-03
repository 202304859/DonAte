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
        let confirmPassword = (confirmPasswordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRaw = (phoneNumberTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let fName = (fNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = (lNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // 2) Validate fields
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

        guard password.count >= 8 else {
            showAlert(title: "Invalid Password", message: "Password has to be at least 8 characters long.")
            return
        }

        guard !confirmPassword.isEmpty else {
            showAlert(title: "Missing Confirm Password", message: "Please confirm your password.")
            return
        }

        guard password == confirmPassword else {
            showAlert(title: "Passwords Do Not Match", message: "Please make sure both passwords match.")
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

        guard !fName.isEmpty else {
            showAlert(title: "Missing First Name", message: "Please enter your first name.")
            return
        }

        guard !lName.isEmpty else {
            showAlert(title: "Missing Last Name", message: "Please enter your last name.")
            return
        }

        let phone = phoneRaw.filter { $0.isNumber }

        // 3) Create user in Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self.showAlert(title: "Error", message: "Could not create user. Please try again.")
                return
            }

            // 4) Create user document in Firestore (username will be added in next screen)
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "firstName": fName,
                "lastName": lName,
                "email": email,
                "phone": phone,
                "points": 0,
                "dateJoined": Timestamp(date: Date()),
                "address": []
            ]

            db.collection("Users").document(uid).setData(userData, merge: true) { error in
                if let error = error {
                    self.showAlert(
                        title: "Database Error",
                        message: "Account created, but failed to save profile data.\n\(error.localizedDescription)"
                    )
                    return
                }

                // 5) Success alert then go to Create Username screen via segue
                let alert = UIAlertController(
                    title: "Success!",
                    message: "Your account has been created.",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.performSegue(withIdentifier: "goToCreateUsername", sender: nil)
                })

                self.present(alert, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep your header
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    private func isValidPhone8Digits(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }
        return digitsOnly.count == 8 && digitsOnly.allSatisfy { $0.isNumber }
    }
}
