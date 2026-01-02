//
//  RequestInfoViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 02/01/2026.
//

import UIKit

class RequestInfoViewController: UIViewController {

    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBAction func sendTapped(_ sender: UIButton) {
        showSuccessAlert()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

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
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success!",
            message: "The request has been sent to BahrainiYouthKitchen", // TODO: for now a placeholder
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
