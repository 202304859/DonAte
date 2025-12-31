//
//  TermsOfServiceViewController.swift
//  DonAte
//
//  Created by Claude on 30/12/2025.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    // MARK: - Properties
    var showAcceptDeclineButtons: Bool = false
    var onAccept: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTermsOfService()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Terms of Service"
        
        // Configure text view
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .darkGray
        textView.backgroundColor = .systemBackground
        
        // Configure buttons
        if showAcceptDeclineButtons {
            acceptButton.isHidden = false
            declineButton.isHidden = false
            
            acceptButton.layer.cornerRadius = 25
            acceptButton.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
            
            declineButton.layer.cornerRadius = 25
            declineButton.layer.borderWidth = 2
            declineButton.layer.borderColor = UIColor.systemRed.cgColor
            declineButton.setTitleColor(.systemRed, for: .normal)
        } else {
            acceptButton.isHidden = true
            declineButton.isHidden = true
        }
    }
    
    private func loadTermsOfService() {
        let termsText = """
        Terms of Service
        
        Last Updated: December 30, 2025
        
        Welcome to DonAte! These Terms of Service ("Terms") govern your use of the DonAte mobile application and services.
        
        1. Acceptance of Terms
        By creating an account and using DonAte, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use our services.
        
        2. User Accounts
        2.1 Registration
        You must provide accurate and complete information when creating an account. You are responsible for maintaining the confidentiality of your account credentials.
        
        2.2 User Types
        DonAte supports two main user types:
        - Donors: Individuals or organizations donating food
        - Collectors: Authorized entities collecting donated food
        
        2.3 Account Security
        You are responsible for all activities that occur under your account. Notify us immediately of any unauthorized use.
        
        3. Food Donations
        3.1 Donor Responsibilities
        - Donors must ensure that donated food is safe for consumption
        - Food must meet all applicable health and safety standards
        - Accurate descriptions and expiration dates must be provided
        - Donors should follow proper food handling and storage guidelines
        
        3.2 Collector Responsibilities
        - Collectors must be authorized organizations or individuals
        - Food must be collected in a timely manner
        - Proper food safety protocols must be followed
        - Food must be distributed to those in need
        
        4. Prohibited Activities
        You may not:
        - Donate unsafe or contaminated food
        - Misrepresent the quality or quantity of donations
        - Use the service for commercial purposes
        - Violate any applicable laws or regulations
        - Share your account with others
        
        5. Privacy and Data
        5.1 Information Collection
        We collect and process personal information as described in our Privacy Policy, including:
        - Account information (name, email, phone number)
        - Location data
        - Donation history and statistics
        - Profile preferences
        
        5.2 Data Usage
        Your information is used to:
        - Facilitate food donations
        - Improve our services
        - Generate impact statistics
        - Communicate with you about the service
        
        6. Liability and Disclaimers
        6.1 Service Availability
        DonAte is provided "as is" without warranties of any kind. We do not guarantee uninterrupted access to our services.
        
        6.2 Food Safety
        While we encourage safe food handling practices, DonAte is not responsible for food safety issues that arise from improper handling by users.
        
        6.3 Limitation of Liability
        To the maximum extent permitted by law, DonAte shall not be liable for any indirect, incidental, or consequential damages arising from your use of the service.
        
        7. Intellectual Property
        All content, features, and functionality of DonAte are owned by us and protected by intellectual property laws. You may not copy, modify, or distribute our content without permission.
        
        8. Termination
        8.1 By You
        You may terminate your account at any time by contacting us or using the account deletion feature.
        
        8.2 By Us
        We reserve the right to suspend or terminate accounts that violate these Terms or engage in fraudulent activity.
        
        9. Changes to Terms
        We may update these Terms from time to time. Continued use of DonAte after changes constitutes acceptance of the updated Terms.
        
        10. Dispute Resolution
        Any disputes arising from these Terms shall be resolved through arbitration in accordance with applicable laws.
        
        11. Governing Law
        These Terms are governed by the laws of the jurisdiction in which DonAte operates.
        
        12. Contact Information
        If you have questions about these Terms, please contact us at:
        Email: support@donate-app.com
        
        13. Miscellaneous
        13.1 Severability
        If any provision of these Terms is found to be unenforceable, the remaining provisions will continue in full force.
        
        13.2 Entire Agreement
        These Terms constitute the entire agreement between you and DonAte regarding the use of our services.
        
        13.3 No Waiver
        Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.
        
        By using DonAte, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.
        
        Thank you for helping us reduce food waste and support those in need!
        """
        
        textView.text = termsText
    }
    
    // MARK: - Actions
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        onAccept?()
        dismiss(animated: true)
    }
    
    @IBAction func declineButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
