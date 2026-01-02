//
//  EditProfileViewController.swift
//  DonAte
//
//  ✅ FIXED: Proper dismissal - returns to ProfileViewController, not login
//  ✅ FIXED: Handles navigation correctly
//  Updated: January 2, 2026
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import UniformTypeIdentifiers

class EditProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var userProfile: UserProfile?
    private let datePicker = UIDatePicker()
    private let logoImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("✅ EditProfileViewController loaded")
        print("📍 Navigation: \(navigationController != nil ? "Has Nav Controller" : "No Nav Controller")")
        print("📍 Presented: \(isBeingPresented ? "YES" : "NO")")
        
        addGreenHeader()
        addLogoToHeader()
        setupUI()
        setupDatePicker()
        setupKeyboardHandling()
        populateFields()
    }
    
    // MARK: - Add Green Header
    private func addGreenHeader() {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        view.insertSubview(headerView, at: 0)
    }
    
    // MARK: - Add Logo to Header
    private func addLogoToHeader() {
        logoImageView.image = UIImage(named: "DonAte_Logo_Transparent")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.bringSubviewToFront(logoImageView)
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Edit Profile"
        
        // Profile image
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0).cgColor
        
        // Set default image first
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        
        // Add tap gesture to profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        // Configure text fields
        configureTextField(fullNameTextField, placeholder: "Full Name", icon: "person.fill")
        configureTextField(emailTextField, placeholder: "Email", icon: "envelope.fill")
        configureTextField(phoneNumberTextField, placeholder: "Phone Number", icon: "phone.fill")
        configureTextField(locationTextField, placeholder: "Location", icon: "location.fill")
        configureTextField(dateOfBirthTextField, placeholder: "Date of Birth", icon: "calendar")
        
        // Disable email editing
        emailTextField.isEnabled = false
        emailTextField.alpha = 0.6
        
        // Configure buttons
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0).cgColor
        cancelButton.setTitleColor(UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0), for: .normal)
        
        activityIndicator.isHidden = true
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, icon: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.delegate = self
        
        // Add icon
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        containerView.addSubview(iconView)
        textField.leftView = containerView
        textField.leftViewMode = .always
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = toolbar
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func populateFields() {
        guard let profile = userProfile else {
            print("⚠️ No user profile provided")
            return
        }
        
        print("✅ Populating fields for: \(profile.fullName)")
        
        fullNameTextField.text = profile.fullName
        emailTextField.text = profile.email
        phoneNumberTextField.text = profile.phoneNumber
        locationTextField.text = profile.location
        
        if let dob = profile.dateOfBirth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateOfBirthTextField.text = dateFormatter.string(from: dob)
            datePicker.date = dob
        }
        
        // Load profile image with error handling
        if let imageURLString = profile.profileImageURL,
           !imageURLString.isEmpty,
           let imageURL = URL(string: imageURLString) {
            print("🖼️ Attempting to load image from: \(imageURLString)")
            loadImage(from: imageURL)
        } else {
            print("ℹ️ No profile image URL, using default")
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Image load error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    self.profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Response: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("❌ Image not found (HTTP \(httpResponse.statusCode))")
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        self.profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
                    }
                    return
                }
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Invalid image data")
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    self.profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
                }
                return
            }
            
            DispatchQueue.main.async {
                print("✅ Image loaded successfully")
                self.profileImageView.image = image
            }
        }.resume()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveProfile()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismissProperly()
    }
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose a photo source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "📷 Camera", style: .default) { [weak self] _ in
                self?.openCamera()
            })
        }
        
        alert.addAction(UIAlertAction(title: "🖼️ Photo Library", style: .default) { [weak self] _ in
            self?.openPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "📁 Files (Desktop, iCloud)", style: .default) { [weak self] _ in
            self?.openFilePicker()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = profileImageView
            popoverController.sourceRect = profileImageView.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func datePickerDone() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
        dateOfBirthTextField.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - ✅ FIXED: Proper Dismissal
    private func dismissProperly() {
        print("📍 Dismissing EditProfileViewController...")
        print("📍 Has Navigation Controller: \(navigationController != nil)")
        print("📍 Presenting VC: \(presentingViewController != nil)")
        
        // If we're in a navigation controller, pop back
        if let navController = navigationController {
            print("✅ Popping from navigation controller")
            navController.popViewController(animated: true)
        }
        // Otherwise, dismiss modally
        else {
            print("✅ Dismissing modally")
            dismiss(animated: true)
        }
    }
    
    // MARK: - Image Selection Methods
    private func openCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    private func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openFilePicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    // MARK: - Save Profile
    private func saveProfile() {
        guard var profile = userProfile else {
            showAlert(title: "Error", message: "No profile data available")
            return
        }
        
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your full name")
            return
        }
        
        profile.fullName = fullName
        profile.phoneNumber = phoneNumberTextField.text
        profile.location = locationTextField.text
        profile.dateOfBirth = datePicker.date
        
        showLoading(true)
        
        FirebaseManager.shared.updateUserProfile(profile) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showLoading(false)
                
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Profile updated successfully") {
                        // ✅ FIXED: Use proper dismissal method
                        self.dismissProperly()
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to update profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Upload Image Helper
    private func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.7),
              let uid = FirebaseManager.shared.currentUser?.uid else {
            showAlert(title: "Error", message: "Failed to process image")
            return
        }
        
        print("📤 Starting image upload for UID: \(uid)")
        
        let loadingAlert = UIAlertController(title: nil, message: "Uploading image...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)
        
        FirebaseManager.shared.uploadProfileImage(uid: uid, imageData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let imageURL):
                        print("✅ Image uploaded successfully: \(imageURL)")
                        
                        self.profileImageView.image = image
                        
                        if var profile = self.userProfile {
                            profile.profileImageURL = imageURL
                            self.userProfile = profile
                        }
                        
                        self.showAlert(title: "Success", message: "Profile picture updated successfully!")
                        
                    case .failure(let error):
                        print("❌ Upload failed: \(error.localizedDescription)")
                        self.showAlert(title: "Upload Failed", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            locationTextField.becomeFirstResponder()
        case locationTextField:
            dateOfBirthTextField.becomeFirstResponder()
        case dateOfBirthTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            uploadProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            uploadProfileImage(originalImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.uploadProfileImage(image)
                    }
                }
            }
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension EditProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        if url.startAccessingSecurityScopedResource() {
            defer { url.stopAccessingSecurityScopedResource() }
            
            if let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                uploadProfileImage(image)
            }
        }
    }
}
