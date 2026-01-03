//
//  DonationRejectionViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit
extension Notification.Name {
    static let donationApproved = Notification.Name("donationApproved")
    static let donationRejected = Notification.Name("donationRejected")
}
    
class DonationRejectionViewController: UIViewController {

    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var checkButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCheckboxes()

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        grabberView.layer.cornerRadius = 2.5
        
        containerView.layer.cornerRadius = 43
                containerView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
        containerView.clipsToBounds = true
    }
    
    private func setupCheckboxes() {
            for button in checkButtons {
                button.setImage(UIImage(systemName: "square"), for: .normal)
                button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
                button.tintColor = .systemGray
                button.isSelected = false
            }
        }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        showRejectionConfirmation()
    }
    
    private func submitRejection() {
        //fake delay for now)
        // rejectApplication()
        showSuccessAlert()
    }
    
    private func showRejectionConfirmation() {
        let alert = UIAlertController(
            title: "Rejection Confirmation",
            message: "Are you sure you want to reject this donation?",
            preferredStyle: .alert
        )

        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            self.submitRejection()
        }
        yes.setValue(UIColor.color1, forKey: "titleTextColor")


        let no = UIAlertAction(title: "No", style: .cancel)
        no.setValue(UIColor.lightGray, forKey: "titleTextColor")
        alert.addAction(yes)
        alert.addAction(no)

        present(alert, animated: true)
    }
    
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success!",
            message: "The rejection form has been sent to the donor",
            preferredStyle: .alert
        )

        let close = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.finishAndReturn()
        }
        close.setValue(UIColor.lightGray, forKey: "titleTextColor")

        alert.addAction(close)
        present(alert, animated: true)
    }
    
    private func finishAndReturn() {
        NotificationCenter.default.post(
            name: .applicationRejected,
            object: nil
        )

        dismiss(animated: true)
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



