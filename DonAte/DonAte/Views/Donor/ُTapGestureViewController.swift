//
//  ُTapGestureViewController.swift
//  DonAte
//
//  Created by BP-36-201-04 on 15/12/2025.
//

import UIKit

class _TapGestureViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //identifiers
    //IB theres functions and variables
    @IBAction func gestureTap(_ sender: Any) {
        
        performSegue(withIdentifier: "gestureTap", sender: nil)
        
    }
    
    @IBAction func tapGesture2(_ sender: Any) {
        
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
