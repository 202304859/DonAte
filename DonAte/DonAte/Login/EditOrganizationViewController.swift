//
//  EditOrganizationViewController.swift
//  DonAte
//
//  Edit organization profile with the same design as the screenshot
//  January 2, 2026
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class EditOrganizationViewController: UIViewController {
    
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let changePictureButton = UIButton(type: .system)
    
    private let organizationNameLabel = UILabel()
    private let organizationNameTextField = UITextField()
    
    private let organizationTypeLabel = UILabel()
    private let charityCheckBox = UIButton(type: .system)
    private let communityServiceCheckBox = UIButton(type: .system)
    private let environmentalProtectionCheckBox = UIButton(type: .system)
    
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let contactPersonLabel = UILabel()
    private let contactPersonTextField = UITextField()
    
    private let cancelButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Data Properties
    var organizationData: [String: Any] = [:]
    var organizationTypes: Set<String> = []
    private var selectedImage: UIImage?
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    private let lightGreen = UIColor(red: 200/255, green: 240/255, blue: 200/255, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadExistingData()
        
        // Keyboard handling
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            headerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Back button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Title
        titleLabel.text = "Edit Profile"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Profile Image
        profileImageView.image = UIImage(systemName: "building.2.circle.fill")
        profileImageView.tintColor = UIColor(red: 147/255, green: 112/255, blue: 219/255, alpha: 1.0) // Purple color
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 60
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Change Picture Button
        changePictureButton.setTitle("Change Picture", for: .normal)
        changePictureButton.setTitleColor(.black, for: .normal)
        changePictureButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        changePictureButton.addTarget(self, action: #selector(changePictureTapped), for: .touchUpInside)
        changePictureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changePictureButton)
        
        NSLayoutConstraint.activate([
            changePictureButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            changePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Organization Name
        setupLabel(organizationNameLabel, text: "Organization Name")
        setupTextField(organizationNameTextField, placeholder: "Full name of the organization.")
        
        // Organization Type
        setupLabel(organizationTypeLabel, text: "Organization Type")
        setupCheckBox(charityCheckBox, title: "Charity", action: #selector(charityTapped))
        setupCheckBox(communityServiceCheckBox, title: "Community Service", action: #selector(communityServiceTapped))
        setupCheckBox(environmentalProtectionCheckBox, title: "Environmental Protection", action: #selector(environmentalProtectionTapped))
        
        // Description
        setupLabel(descriptionLabel, text: "Description")
        setupTextView(descriptionTextView)
        
        // Contact Person
        setupLabel(contactPersonLabel, text: "Contact Person")
        setupTextField(contactPersonTextField, placeholder: "John Doe")
        
        // Add all to content view
        [organizationNameLabel, organizationNameTextField,
         organizationTypeLabel, charityCheckBox, communityServiceCheckBox, environmentalProtectionCheckBox,
         descriptionLabel, descriptionTextView,
         contactPersonLabel, contactPersonTextField].forEach {
            contentView.addSubview($0)
        }
        
        // Buttons
        setupButton(cancelButton, title: "Cancel", backgroundColor: .white, textColor: darkGreen, action: #selector(cancelTapped), bordered: true)
        setupButton(nextButton, title: "Next", backgroundColor: lightGreen, textColor: .black, action: #selector(nextTapped), bordered: false)
        
        view.addSubview(cancelButton)
        view.addSubview(nextButton)
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .gray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = lightGreen.cgColor
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCheckBox(_ button: UIButton, title: String, action: Selector) {
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.setTitle(" \(title)", for: .normal)
        button.tintColor = lightGreen
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = lightGreen.cgColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "A short description of the organization's mission and purpose."
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor, textColor: UIColor, action: Selector, bordered: Bool) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 25
        
        if bordered {
            button.layer.borderWidth = 2
            button.layer.borderColor = lightGreen.cgColor
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Organization Name
            organizationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            organizationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            organizationNameTextField.topAnchor.constraint(equalTo: organizationNameLabel.bottomAnchor, constant: 8),
            organizationNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            organizationNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Organization Type
            organizationTypeLabel.topAnchor.constraint(equalTo: organizationNameTextField.bottomAnchor, constant: 20),
            organizationTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizationTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            charityCheckBox.topAnchor.constraint(equalTo: organizationTypeLabel.bottomAnchor, constant: 12),
            charityCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charityCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            charityCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            communityServiceCheckBox.topAnchor.constraint(equalTo: charityCheckBox.bottomAnchor, constant: 8),
            communityServiceCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            communityServiceCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            communityServiceCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            environmentalProtectionCheckBox.topAnchor.constraint(equalTo: communityServiceCheckBox.bottomAnchor, constant: 8),
            environmentalProtectionCheckBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            environmentalProtectionCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            environmentalProtectionCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: environmentalProtectionCheckBox.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Contact Person
            contactPersonLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            contactPersonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactPersonTextField.topAnchor.constraint(equalTo: contactPersonLabel.bottomAnchor, constant: 8),
            contactPersonTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactPersonTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactPersonTextField.heightAnchor.constraint(equalToConstant: 50),
            contactPersonTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Buttons
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Load Existing Data
    private func loadExistingData() {
        guard let uid = FirebaseManager.shared.currentUser?.uid else { return }
        
        activityIndicator.startAnimating()
        
        let db = Firestore.firestore()
        db.collection("organizations").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let data = snapshot?.data() {
                    self.populateFields(with: data)
                }
            }
        }
    }
    
    private func populateFields(with data: [String: Any]) {
        if let name = data["name"] as? String {
            organizationNameTextField.text = name
            organizationNameTextField.textColor = .black
        }
        
        if let types = data["types"] as? [String] {
            for type in types {
                switch type {
                case "Charity":
                    charityCheckBox.isSelected = true
                    organizationTypes.insert("Charity")
                case "Community Service":
                    communityServiceCheckBox.isSelected = true
                    organizationTypes.insert("Community Service")
                case "Environmental Protection":
                    environmentalProtectionCheckBox.isSelected = true
                    organizationTypes.insert("Environmental Protection")
                default:
                    break
                }
            }
        }
        
        if let description = data["description"] as? String, !description.isEmpty {
            descriptionTextView.text = description
            descriptionTextView.textColor = .black
        }
        
        if let contactPerson = data["contactPerson"] as? String {
            contactPersonTextField.text = contactPerson
            contactPersonTextField.textColor = .black
        }
        
        // Load profile image if available
        if let imageURL = data["profileImageURL"] as? String {
            loadProfileImage(from: imageURL)
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changePictureTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc private func charityTapped() {
        charityCheckBox.isSelected.toggle()
        if charityCheckBox.isSelected {
            organizationTypes.insert("Charity")
        } else {
            organizationTypes.remove("Charity")
        }
    }
    
    @objc private func communityServiceTapped() {
        communityServiceCheckBox.isSelected.toggle()
        if communityServiceCheckBox.isSelected {
            organizationTypes.insert("Community Service")
        } else {
            organizationTypes.remove("Community Service")
        }
    }
    
    @objc private func environmentalProtectionTapped() {
        environmentalProtectionCheckBox.isSelected.toggle()
        if environmentalProtectionCheckBox.isSelected {
            organizationTypes.insert("Environmental Protection")
        } else {
            organizationTypes.remove("Environmental Protection")
        }
    }
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextTapped() {
        // Validate
        guard let orgName = organizationNameTextField.text, !orgName.isEmpty else {
            showAlert(message: "Please enter organization name")
            return
        }
        
        guard !organizationTypes.isEmpty else {
            showAlert(message: "Please select at least one organization type")
            return
        }
        
        guard let contactPerson = contactPersonTextField.text, !contactPerson.isEmpty else {
            showAlert(message: "Please enter contact person name")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        if description.isEmpty || description == "A short description of the organization's mission and purpose." {
            showAlert(message: "Please enter organization description")
            return
        }
        
        // Save data
        saveOrganizationData(name: orgName, types: Array(organizationTypes), description: description, contactPerson: contactPerson)
    }
    
    private func saveOrganizationData(name: String, types: [String], description: String, contactPerson: String) {
        guard let uid = FirebaseManager.shared.currentUser?.uid else {
            showAlert(message: "User not logged in")
            return
        }
        
        activityIndicator.startAnimating()
        nextButton.isEnabled = false
        
        let db = Firestore.firestore()
        var data: [String: Any] = [
            "name": name,
            "types": types,
            "description": description,
            "contactPerson": contactPerson,
            "updatedAt": Timestamp()
        ]
        
        // Upload image if selected
        if let image = selectedImage {
            uploadProfileImage(image, uid: uid) { [weak self] imageURL in
                guard let self = self else { return }
                
                if let imageURL = imageURL {
                    data["profileImageURL"] = imageURL
                }
                
                self.updateFirestore(uid: uid, data: data)
            }
        } else {
            updateFirestore(uid: uid, data: data)
        }
    }
    
    private func uploadProfileImage(_ image: UIImage, uid: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("organization_profiles/\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("❌ Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
    
    private func updateFirestore(uid: String, data: [String: Any]) {
        let db = Firestore.firestore()
        
        db.collection("organizations").document(uid).setData(data, merge: true) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.nextButton.isEnabled = true
                
                if let error = error {
                    print("❌ Error saving organization: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to save changes")
                } else {
                    print("✅ Organization data saved successfully")
                    self.showSuccessAlert()
                }
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Organization details updated successfully",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - UITextViewDelegate
extension EditOrganizationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "A short description of the organization's mission and purpose."
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditOrganizationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            profileImageView.image = originalImage
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
