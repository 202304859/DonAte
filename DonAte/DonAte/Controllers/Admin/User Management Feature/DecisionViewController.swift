//
//  DecisionViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class DecisionViewController: UIViewController {

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
                button.setImage(UIImage(systemName: "circle"), for: .normal)
                button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
                button.tintColor = .systemGray
                button.isSelected = false
            }
        }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        for button in checkButtons {
               button.isSelected = (button == sender)
           }
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        showApplyConfirmation()
    }
    
    
    private func showApplyConfirmation() {
        let alert = UIAlertController(
            title: "Success!",
            message: "The decision has been applied!",
            preferredStyle: .alert
        )

        let close = UIAlertAction(title: "Close", style: .cancel){ _ in
            self.dismiss(animated: true)}
        close.setValue(UIColor.lightGray, forKey: "titleTextColor")

        alert.addAction(close)
        present(alert, animated: true)
        
        
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
