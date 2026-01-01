//
//  UploadDonationPhotoViewController.swift
//  DonAte
//
//  Created by BP-36-213-18 on 01/01/2026.
//

import UIKit
extension UploadDonationPhotoViewController : UIImagePickerControllerDelegate, UINavigationBarDelegate{
    func openPhotoPicker(){
        guard selectedImages.count < 3 else {
            print("max 3 photos")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
            //updateImageViews()
        }
        dismiss(animated: true)
    }
    
}

class UploadDonationPhotoViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func hideImageViews(){
        imageView1.isHidden = true
        imageView2.isHidden = true
        imageView3.isHidden = true

        
    }
    
    @IBAction func addPhotosTapped(_ sender: UIButton) {
        //openPhotoPicker()
    }
    
    func updateImage(){
        let imageViews = [imageView1,imageView2,imageView3]
        
        for i in 0..<imageViews.count {
            if i < selectedImages.count{
                imageViews[i]?.image = selectedImages[i]
                imageViews[i]?.isHidden = false
            }else{
                imageViews[i]?.isHidden = true
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
