//
//  DonorImpactViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit

class DonorImpactViewController: UIViewController {
    
    

    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareTapped(_ sender: UIButton) {
    

        //Hide the Share button before rendering PDF
            shareButton.isHidden = true
        

            //Force layout update
            view.layoutIfNeeded()

            //create PDF from the view
            let pdfURL = createPDF(from: view)

            //show the Share button again
            shareButton.isHidden = false

                //open share sheet so user can save to Files / share
                presentShareSheet(for: pdfURL, from: sender)
            }

            private func createPDF(from targetView: UIView) -> URL {

                // make sure the layout is up to date before rendering
                targetView.layoutIfNeeded()

                // use the view's bounds as the PDF page size (same as your screen)
                let pageRect = CGRect(origin: .zero, size: targetView.bounds.size)

                // create renderer for PDF
                let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

                // save PDF in temporary directory
                let tempURL = FileManager.default.temporaryDirectory
                let fileURL = tempURL.appendingPathComponent("ImpactSummary.pdf")

                //render the view into a PDF page
                do {
                    try renderer.writePDF(to: fileURL) { context in
                        context.beginPage()

                        // draw the view onto the PDF
                        targetView.layer.render(in: context.cgContext)
                    }
                } catch {
                    print("Failed to create PDF:", error) //exception handling
                }

                return fileURL
            }

            private func presentShareSheet(for fileURL: URL, from sourceView: UIView) {

                // ceate share controller with the generated PDF
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

                //ipad fix: show the share sheet as a popover
                if let popover = activityVC.popoverPresentationController {
                    popover.sourceView = sourceView
                    popover.sourceRect = sourceView.bounds
                }

                //pesent share sheet
                present(activityVC, animated: true)
            }
        
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        
        
            let navBar = CustomNavigationBar()
            navBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navBar)
            
            NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalTo: view.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navBar.heightAnchor.constraint(equalToConstant: 150)
            ])
            
            navBar.configure(style: .backWithTitle(title: "Impact Summary"))
            navBar.onBackTapped = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
               
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    

    

}
