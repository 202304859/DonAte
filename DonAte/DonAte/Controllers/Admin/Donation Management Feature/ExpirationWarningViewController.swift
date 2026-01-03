//
//  EpirationWarningViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import UIKit

class ExpirationWarningViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var isSelectAllChecked = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        tableView.dataSource = self
        tableView.delegate = self
        setupCheckboxes()
    }
    
    private func setupView() {
        
        grabberView.layer.cornerRadius = 2.5
        // it is not working i dont know why
        containerView.layer.cornerRadius = 43
                containerView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
        containerView.clipsToBounds = true
    }
    
    private func setupCheckboxes() {
                checkButton.setImage(UIImage(systemName: "square"), for: .normal)
                checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
                checkButton.tintColor = .systemGray
                checkButton.isSelected = false
            
        }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func selectAllTapped(_ sender: UIButton) {
        isSelectAllChecked.toggle()
        sender.isSelected = isSelectAllChecked

        tableView.reloadData()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        showSendingConfirmation()
    }
    
    private func showSendingConfirmation() {
        let alert = UIAlertController(
            title: "Success!",
            message: "The expiration warning has been sent.",
            preferredStyle: .alert
        )

        let close = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        close.setValue(UIColor.lightGray, forKey: "titleTextColor")

        alert.addAction(close)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // temp
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectorWarningCell", for: indexPath) as! ExpirationTableViewCell
        cell.configure(isChecked: isSelectAllChecked)
            return cell
        
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
