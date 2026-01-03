import UIKit
import FirebaseAuth
import FirebaseFirestore

final class DonorCreateUsernameViewController: UIViewController {

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!

    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep your header code
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

        userNameTextField.autocapitalizationType = .none
        userNameTextField.autocorrectionType = .no
    }

    @IBAction private func nextButtonTapped(_ sender: UIButton) {

        // 1) Must be logged in (registration created the account)
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "Please register/login first.")
            return
        }

        // 2) Read + normalize
        let raw = userNameTextField.text ?? ""
        let username = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        // 3) Validate
        guard isValidUsername(username) else {
            showAlert(title: "Invalid Username",
                      message: "Use 3–20 characters: letters, numbers, underscore, or dot.")
            return
        }

        setLoading(true)

        // 4) Check availability
        checkUsernameAvailability(username) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)

            switch result {
            case .success(let isAvailable):
                if !isAvailable {
                    self.showAlert(title: "Username Taken",
                                   message: "That username already exists. Please choose another one.")
                    return
                }

                // 5) Save username to this user's Firestore document
                self.db.collection("Users").document(uid).updateData(["username": username]) { err in
                    if let err = err {
                        self.showAlert(title: "Save Failed", message: err.localizedDescription)
                        return
                    }

                    // 6) Go to Add Address via segue
                    self.performSegue(withIdentifier: "goToNewDonorAddress", sender: nil)
                }

            case .failure:
                self.showAlert(title: "Can't Verify Username",
                               message: "We couldn't check usernames right now. Please try again.")
            }
        }
    }

    private func checkUsernameAvailability(_ username: String,
                                           completion: @escaping (Result<Bool, Error>) -> Void) {

        db.collection("Users")
            .whereField("username", isEqualTo: username)
            .limit(to: 1)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                let isTaken = !(snapshot?.documents.isEmpty ?? true)
                completion(.success(!isTaken))
            }
    }

    private func isValidUsername(_ username: String) -> Bool {
        guard username.count >= 3 && username.count <= 20 else { return false }
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789_.")
        return username.unicodeScalars.allSatisfy { allowed.contains($0) }
    }

    private func setLoading(_ loading: Bool) {
        nextButton.isEnabled = !loading
        nextButton.alpha = loading ? 0.6 : 1.0
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
