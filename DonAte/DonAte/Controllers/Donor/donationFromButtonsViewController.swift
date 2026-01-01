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
    
    
    //let donationRef = db.collection("donations").document()
    
    //let donationId = donationRef.documentID
    
    //donationRef.setData(["donorID": Auth.auth().currentUser?.uid ?? "","donationType": "openTime","ngoName": "left open", "images":[], "status": "draft"])
    
    
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
