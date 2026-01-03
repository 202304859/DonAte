//
//  foodGroupsViewController.swift
//  DonAte
//
//  Created by BP-36-213-18 on 01/01/2026.
//

import UIKit
import Firebase

class foodGroupsViewController: UIViewController {
    
    let db = Firestore.firestore()
    var donationId: String! // passed from previous screeeen
    var selectedGroups: [String] = [] //store raw strings
    
    
    @IBOutlet weak var otherTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherTextField.isEnabled = false // other field disabled initially

        // Do any additional setup after loading the view.
    }

    //foof group buttons
    
    
    @IBAction func foodGroupTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {return}
        
        
        //selected??
        if selectedGroups.contains(title){
            selectedGroups.removeAll { $0 == title }
            
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            sender.isSelected = false
            if title == "Other" {
                otherTextField.isEnabled = false
                otherTextField.text = ""
            }
        }else {
            selectedGroups.append(title)
            
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.isSelected = true
            if title == "Other"{
                otherTextField.isEnabled = true
            }
        }
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        var groupsToSave = selectedGroups
        
        //if other is selected add text field value
        if selectedGroups.contains("Other"), let otherText = otherTextField.text, !otherText.isEmpty {
            groupsToSave.append(otherText)
        }
        
        //save to firestore under the draft donation
        db.collection("Donations").document(donationId).updateData(["food.foodGroup": groupsToSave]) {
            error in
            if let error = error {
                print("Error saving food groups:",error.localizedDescription)
            }else{
                print("Food groups saved: ", groupsToSave)
                //self.goToFoodType()
            }
        }
        
        func goToFoodType(){
            //later maybe??? idk
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
