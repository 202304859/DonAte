//
//  donationFromButtonsViewController.swift
//  DonAte
//
//  Created by BP-36-213-18 on 01/01/2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class donationFromButtonsViewController: UIViewController {

    let db = Firestore.firestore()
    
    //once you click the leaveOpen button it will pass these values through the function createDraftDonation and only will fill temp fields as a draft
    
    //donation will be left open no ngo assigned
    @IBAction func leaveOpenTapped(_ sender: UIButton) {
        createDraftDonation(
            donationType: "oneTime",
            ngoId : nil,
            ngoName : "Left Open" ){
                donationId in print("Donation created: ", donationId)
                //this will give us the donationId once fireStore creates it
            }
    }
    
    // donation will have ngo chosen later
    @IBAction func ChooseNGOTapped(_ sender: UIButton) {
        createDraftDonation(
            donationType: "oneTime",
            ngoId : nil,
            ngoName : nil){
                donationId in print("Donation created: ", donationId)
            }
    }
    //this creates the firestore document and saves basic fields for draft donation
    func createDraftDonation(donationType: String, ngoId: String?, ngoName: String?, completion: @escaping (String)-> Void){
        
        //make sure there is a logged in user and we need a donorId for the donation
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No logged in user")
            return
            
        }
        
        //creates a new document in the 'donations' collection
        //automatically makes a unique id for this document
        let donationRef = db.collection("Donations").document()
        
        donationRef.setData([
            "donationType": donationType,
            "donorId": userId,
            "status": "draft",
            "ngoId": ngoId as Any,
            "ngoName": ngoName as Any,
            "images":[]
//set inital data fir the donation until changes or filled later
        ]){error in
            if let error = error {
                print("Firestore: ", error.localizedDescription)
            }else{
                completion(donationRef.documentID)
            }
            //check for errors if successful call the completion closure with the donation id
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
