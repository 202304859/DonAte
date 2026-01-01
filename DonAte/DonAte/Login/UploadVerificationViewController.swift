//
//  UploadVerificationViewController.swift
//  DonAte
//
//  ✅ UPDATED: Added scanner animation and green checkmark
//  January 1, 2026
//

import UIKit

class UploadVerificationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Properties
    private let titleLabel = UILabel()
    private let documentImageView = UIImageView()
    private let uploadButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    // Scanner Animation
    private let scannerLine = UIView()
    private let successCheckmark = UIImageView()
    
    // MARK: - Data Properties
    var organizationData: [String: Any] = [:]
    private var selectedImage: UIImage?
    private var isScanned = false
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupScannerAnimation()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Header
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        // Back button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Title
        titleLabel.text = "Upload an Verification\nDocument"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = darkGreen
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
        
        // Document Image View
        documentImageView.contentMode = .scaleAspectFit
        documentImageView.layer.cornerRadius = 12
        documentImageView.layer.borderWidth = 2
        documentImageView.layer.borderColor = UIColor.lightGray.cgColor
        documentImageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        documentImageView.image = UIImage(systemName: "doc.text.fill")
        documentImageView.tintColor = .lightGray
        documentImageView.clipsToBounds = true
        documentImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(documentImageView)
        
        // Upload Button
        uploadButton.setTitle("Upload Image", for: .normal)
        uploadButton.backgroundColor = greenColor
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        uploadButton.layer.cornerRadius = 25
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadButton)
        
        // Next Button
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = darkGreen
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.layer.cornerRadius = 25
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.alpha = 0.5 // Disabled by default
        nextButton.isEnabled = false
        view.addSubview(nextButton)
    }
    
    // MARK: - Setup Scanner Animation
    private func setupScannerAnimation() {
        // Scanner Line
        scannerLine.backgroundColor = darkGreen.withAlphaComponent(0.6)
        scannerLine.translatesAutoresizingMaskIntoConstraints = false
        scannerLine.isHidden = true
        documentImageView.addSubview(scannerLine)
        
        // Success Checkmark
        successCheckmark.image = UIImage(systemName: "checkmark.circle.fill")
        successCheckmark.tintColor = darkGreen
        successCheckmark.contentMode = .scaleAspectFit
        successCheckmark.translatesAutoresizingMaskIntoConstraints = false
        successCheckmark.alpha = 0
        view.addSubview(successCheckmark)
        
        NSLayoutConstraint.activate([
            scannerLine.leadingAnchor.constraint(equalTo: documentImageView.leadingAnchor),
            scannerLine.trailingAnchor.constraint(equalTo: documentImageView.trailingAnchor),
            scannerLine.heightAnchor.constraint(equalToConstant: 3),
            
            successCheckmark.centerXAnchor.constraint(equalTo: documentImageView.centerXAnchor),
            successCheckmark.centerYAnchor.constraint(equalTo: documentImageView.centerYAnchor),
            successCheckmark.widthAnchor.constraint(equalToConstant: 100),
            successCheckmark.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            documentImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            documentImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            documentImageView.heightAnchor.constraint(equalToConstant: 400),
            
            uploadButton.topAnchor.constraint(equalTo: documentImageView.bottomAnchor, constant: 30),
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Scanner Animation
    private func startScannerAnimation() {
        // Reset scanner
        scannerLine.isHidden = false
        scannerLine.alpha = 1.0
        
        // Position scanner at top
        scannerLine.frame = CGRect(x: 0, y: 0, width: documentImageView.bounds.width, height: 3)
        
        // Animate scanner moving down
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.scannerLine.frame.origin.y = self.documentImageView.bounds.height - 3
        }) { _ in
            // Animate scanner moving up
            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.scannerLine.frame.origin.y = 0
            }) { _ in
                // Hide scanner and show success
                self.showSuccessCheckmark()
            }
        }
    }
    
    private func showSuccessCheckmark() {
        // Hide scanner line
        scannerLine.isHidden = true
        
        // Change border to green
        UIView.animate(withDuration: 0.3) {
            self.documentImageView.layer.borderColor = self.darkGreen.cgColor
            self.documentImageView.layer.borderWidth = 3
        }
        
        // Show checkmark with scale animation
        successCheckmark.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            self.successCheckmark.alpha = 1.0
            self.successCheckmark.transform = .identity
        }) { _ in
            // Enable next button
            self.enableNextButton()
            
            // Play success haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    private func enableNextButton() {
        isScanned = true
        
        UIView.animate(withDuration: 0.3) {
            self.nextButton.alpha = 1.0
            self.nextButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func uploadTapped() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            self.openImagePicker(sourceType: .camera)
        })
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    @objc private func nextTapped() {
        guard isScanned else {
            showAlert(message: "Please wait for scanning to complete")
            return
        }
        
        // Navigate to registration page
        // Load RegistrationViewController from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
            registrationVC.userRole = "collector"
            registrationVC.organizationData = organizationData
            registrationVC.verificationImage = selectedImage
            navigationController?.pushViewController(registrationVC, animated: true)
            print("✅ Navigating to RegistrationViewController")
        } else {
            print("❌ Could not load RegistrationViewController from storyboard")
            showAlert(message: "Navigation error. Please try again.")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            documentImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            documentImageView.image = originalImage
        }
        
        documentImageView.contentMode = .scaleAspectFill
        documentImageView.clipsToBounds = true
        
        picker.dismiss(animated: true) {
            // Start scanner animation after image is set
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startScannerAnimation()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
