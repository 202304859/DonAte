//
//  LoginViewController.swift
//  DonAte
//
//  Created by BP-36-201-05 on 10/12/2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        // 1) Validate email
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }

        // 2) Validate password
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }

        // 3) Sign in with Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            // 4) Handle error
            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            // 5) Save user ID (optional but matches tutor flow)
            if let userID = authResult?.user.uid {
                UserDefaults.standard.set(userID, forKey: UserDefaultsKeys.userID)
            }

            // 6) Navigate to Donor Tab Bar
            self.navigateToDonorDashboard()
        }
    }

    private func navigateToDonorDashboard() {

        // 1) Load DonorDashboard storyboard
        let storyboard = UIStoryboard(name: "DonorDashboard", bundle: nil)

        // 2) Instantiate Tab Bar Controller
        let tabBar = storyboard.instantiateViewController(
            withIdentifier: "donor_tab"
        ) as! DonorTabBarController

        // 3) Present full screen
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
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
                
                
                /*  let alert = UIAlertController(
                 title: "Loaded",
                 message: "LoginViewController is linked correctly",
                 preferredStyle: .alert
                 )
                 
                 alert.addAction(UIAlertAction(title: "OK", style: .default))
                 
                 present(alert, animated: true)*/
                //the above was just to test if the viewController is correctly linked to the storyboard. i have trust issues.
                
            }
            
            
                
            }
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
            
    

