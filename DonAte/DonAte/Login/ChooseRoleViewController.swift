//
//  ChooseRoleViewController.swift
//  DonAte
//
//  ✅ FIXED: Pure programmatic navigation (no storyboard conflicts)
//  Updated: January 2, 2026
//

import UIKit

class ChooseRoleViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var registerTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectorButton: UIButton!
    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    private var selectedRole: String?
    
    // Colors from design
    private let headerGreen = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0) // #B4E7B4
    private let accentGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0) // #74BB6D
    private let darkText = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0) // #1E293B
    private let lightGray = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0) // #CBD5E1
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        setupLoginLink()
        setupPageControl()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        // Set background
        view.backgroundColor = .white
        
        // Header setup
        headerView.backgroundColor = headerGreen
        
        // App name label
        appNameLabel.text = "DonAte"
        appNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textColor = darkText
        
        // Register title
        registerTitleLabel.text = "Register"
        registerTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        registerTitleLabel.textColor = accentGreen
        registerTitleLabel.textAlignment = .center
        
        // Subtitle
        subtitleLabel.text = "Choose your role"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = darkText
        subtitleLabel.textAlignment = .center
    }
    
    private func setupButtons() {
        // Collector button
        styleButton(collectorButton, title: "Collector")
        
        // Donor button
        styleButton(donorButton, title: "Donor")
    }
    
    private func styleButton(_ button: UIButton, title: String) {
        // Background and text
        button.backgroundColor = .white
        button.setTitle(title, for: .normal)
        button.setTitleColor(darkText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        // Border and corner radius
        button.layer.borderWidth = 2
        button.layer.borderColor = accentGreen.cgColor
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        // Add subtle shadow for depth
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
    }
    
    private func setupLoginLink() {
        let text = "Have an account? Login"
        let attributedString = NSMutableAttributedString(string: text)
        
        // Gray color for "Have an account?"
        let grayRange = (text as NSString).range(of: "Have an account? ")
        attributedString.addAttribute(.foregroundColor, value: lightGray, range: grayRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: grayRange)
        
        // Green color for "Login"
        let loginRange = (text as NSString).range(of: "Login")
        attributedString.addAttribute(.foregroundColor, value: accentGreen, range: loginRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .semibold), range: loginRange)
        
        loginLabel.attributedText = attributedString
        loginLabel.textAlignment = .center
        
        // Make it tappable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = accentGreen
        pageControl.pageIndicatorTintColor = lightGray
        pageControl.isUserInteractionEnabled = false // Just for display, not interactive
    }
    
    // MARK: - Actions
    
    @IBAction func collectorButtonTapped(_ sender: UIButton) {
        selectedRole = "collector"
        print("✅ Collector role selected - starting collector flow")
        
        // Add visual feedback
        animateButtonTap(sender)
        
        // ✅ Create CollectorDetailsViewController programmatically
        let collectorDetailsVC = CollectorDetailsViewController()
        navigationController?.pushViewController(collectorDetailsVC, animated: true)
    }
    
    @IBAction func donorButtonTapped(_ sender: UIButton) {
        selectedRole = "donor"
        print("✅ Donor role selected - navigating to registration")
        
        // Add visual feedback
        animateButtonTap(sender)
        
        // ✅ Load RegistrationViewController from Login storyboard
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let registrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
            registrationVC.userRole = "donor"
            navigationController?.pushViewController(registrationVC, animated: true)
            print("✅ Navigating to RegistrationViewController as donor")
        } else {
            print("❌ Could not load RegistrationViewController from Login storyboard")
            print("⚠️ Make sure RegistrationViewController has Storyboard ID: 'RegistrationViewController' in Login.storyboard")
            showAlert(message: "Navigation error. Please contact support.")
        }
    }
    
    @objc private func loginTapped() {
        print("🔙 Navigating back to login")
        // Dismiss the entire navigation controller to go back to login
        navigationController?.dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Animations
    
    private func animateButtonTap(_ button: UIButton) {
        // Scale down
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            // Scale back up
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
        
        // Highlight effect
        UIView.animate(withDuration: 0.2, animations: {
            button.backgroundColor = self.headerGreen.withAlphaComponent(0.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                button.backgroundColor = .white
            }
        }
    }
}
