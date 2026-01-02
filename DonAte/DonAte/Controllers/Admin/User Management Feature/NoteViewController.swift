//
//  NoteViewController.swift
//  DonAte
//
//  Created by Zahra Almosawi on 02/01/2026.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var containerView: UIView!
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
