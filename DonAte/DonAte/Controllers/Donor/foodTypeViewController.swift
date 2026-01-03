//
//  foodTypeViewController.swift
//  DonAte
//
//  Created by BP-36-213-18 on 01/01/2026.
//

import UIKit
import FirebaseFirestore

class foodTypeViewController: UIViewController {

    let db = Firestore.firestore()
    var donationId: String!
    
    //only one picked
    var selectedFoodType: String?
    
    @IBOutlet weak var otherTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func foodTypeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {return}
        
        //do i even need this tbh??
        //unselectAllFoodTypeButtons()
        
        //select this one
        sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        sender.isSelected = true
        selectedFoodType = title
        
        //other text field
        if title == "Other"{
            otherTextField.isEnabled = true
        }else{
            otherTextField.isEnabled = false
            otherTextField.text = ""
        }
        
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        guard var typeToSave = selectedFoodType else{
            print("no food type selected")
            return
            //should prob change so they cant go without inputting fields
        }
        
        if typeToSave == "Other", let otherText = otherTextField.text, !otherText.isEmpty {
            typeToSave = otherText
        }
        
        
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

}
