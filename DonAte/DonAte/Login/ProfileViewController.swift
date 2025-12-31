//
//  ProfileViewController.swift
//  DonAte
//
//  ✅ FIXED: Proper data passing + Image upload error handling
//  Created by Claude on 31/12/2025.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    // MARK: - Properties
    private var userProfile: UserProfile?
    private var profileMenuItems: [[ProfileMenuItem]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Profile image
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
        profileImageView.contentMode = .scaleAspectFill
        
        // Set default image
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Add tap gesture to profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        // Edit button
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Setup menu items
        setupMenuItems()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func setupMenuItems() {
        // Section 1: Profile Management
        let section1 = [
            ProfileMenuItem(icon: "person.fill", title: "Edit Profile", subtitle: "Update your personal information", action: .editProfile),
            ProfileMenuItem(icon: "chart.bar.fill", title: "Impact Summary", subtitle: "View your donation statistics", action: .impactSummary),
            ProfileMenuItem(icon: "lock.fill", title: "Change Password", subtitle: "Update your password", action: .changePassword)
        ]
        
        // Section 2: Preferences
        let section2 = [
            ProfileMenuItem(icon: "message.fill", title: "Messages", subtitle: "View and manage your messages", action: .dietPreferences),
            ProfileMenuItem(icon: "bell.fill", title: "Notifications", subtitle: "Manage notification settings", action: .notifications),
            ProfileMenuItem(icon: "gearshape.fill", title: "Settings", subtitle: "App settings and preferences", action: .settings)
        ]
        
        // Section 3: Account
        let section3 = [
            ProfileMenuItem(icon: "doc.text.fill", title: "Terms of Service", subtitle: "View terms and conditions", action: .terms),
            ProfileMenuItem(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "Get help and support", action: .help),
            ProfileMenuItem(icon: "arrow.right.square.fill", title: "Logout", subtitle: "Sign out of your account", action: .logout, isDestructive: true)
        ]
        
        profileMenuItems = [section1, section2, section3]
    }
    
    // MARK: - Data Loading
    private func loadUserProfile() {
        guard let uid = FirebaseManager.shared.currentUser?.uid else {
            showAlert(title: "Error", message: "User not logged in")
            return
        }
        
        print("📥 Loading profile for UID: \(uid)")
        
        FirebaseManager.shared.fetchUserProfile(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    print("✅ Profile loaded successfully")
                    self.userProfile = profile
                    self.updateUI(with: profile)
                case .failure(let error):
                    print("❌ Failed to load profile: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to load profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateUI(with profile: UserProfile) {
        nameLabel.text = profile.fullName
        emailLabel.text = profile.email
        phoneLabel.text = profile.phoneNumber ?? "Not provided"
        locationLabel.text = profile.location ?? "Not provided"
        
        // Load profile image with error handling
        if let imageURLString = profile.profileImageURL,
           !imageURLString.isEmpty,
           let imageURL = URL(string: imageURLString) {
            print("🖼️ Loading image from: \(imageURLString)")
            loadImage(from: imageURL)
        } else {
            print("ℹ️ No profile image URL found, using default")
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Image load error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // Use default image on error
                    self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    self.profileImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Invalid image data")
                DispatchQueue.main.async {
                    // Use default image on error
                    self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    self.profileImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
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
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showEditProfile", sender: nil)
    }
    
    @objc private func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func handleMenuAction(_ action: ProfileMenuAction) {
        switch action {
        case .editProfile:
            performSegue(withIdentifier: "showEditProfile", sender: nil)
            
        case .impactSummary:
            performSegue(withIdentifier: "showImpactSummary", sender: nil)
            
        case .changePassword:
            performSegue(withIdentifier: "showChangePassword", sender: nil)
            
        case .dietPreferences:
            performSegue(withIdentifier: "showDietPreferences", sender: nil)
            
        case .notifications:
            performSegue(withIdentifier: "showNotifications", sender: nil)
            
        case .settings:
            performSegue(withIdentifier: "showSettings", sender: nil)
            
        case .terms:
            performSegue(withIdentifier: "showTerms", sender: nil)
            
        case .help:
            performSegue(withIdentifier: "showHelp", sender: nil)
            
        case .logout:
            handleLogout()
        }
    }
    
    private func handleLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            FirebaseManager.shared.logoutUser { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.showAlert(title: "Error", message: "Failed to logout: \(error.localizedDescription)")
                    } else {
                        // Navigate back to login
                        self?.navigateToLogin()
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - ✅ FIXED: Navigation / Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        func getViewController<T>(_ destination: UIViewController) -> T? {
            if let navController = destination as? UINavigationController {
                return navController.viewControllers.first as? T
            }
            return destination as? T
        }
        
        guard let profile = userProfile else {
            print("⚠️ Warning: userProfile is nil during segue")
            return
        }
        
        switch segue.identifier {
        case "showEditProfile":
            if let editVC: EditProfileViewController = getViewController(segue.destination) {
                editVC.userProfile = profile
                print("✅ Passed profile to EditProfile")
            }
            
        case "showImpactSummary":
            if let impactVC: ImpactSummaryViewController = getViewController(segue.destination) {
                impactVC.userProfile = profile
                print("✅ Passed profile to ImpactSummary")
            }
            
        case "showChangePassword":
            print("✅ Navigating to ChangePassword")
            
        case "showDietPreferences":
            if let dietVC: DietPreferencesViewController = getViewController(segue.destination) {
                dietVC.userProfile = profile
                print("✅ Passed profile to DietPreferences")
            }
            
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMenuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as! ProfileMenuCell
        let menuItem = profileMenuItems[indexPath.section][indexPath.row]
        cell.configure(with: menuItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuItem = profileMenuItems[indexPath.section][indexPath.row]
        handleMenuAction(menuItem.action)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .gray
        
        switch section {
        case 0:
            titleLabel.text = "PROFILE MANAGEMENT"
        case 1:
            titleLabel.text = "PREFERENCES"
        case 2:
            titleLabel.text = "ACCOUNT"
        default:
            break
        }
        
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.7),
              let uid = FirebaseManager.shared.currentUser?.uid else {
            return
        }
        
        print("📤 Starting image upload for UID: \(uid)")
        
        // Show loading
        let loadingAlert = UIAlertController(title: nil, message: "Uploading image...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)
        
        // Upload image
        FirebaseManager.shared.uploadProfileImage(uid: uid, imageData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let imageURL):
                        print("✅ Image upload complete, URL: \(imageURL)")
                        
                        // Update UI immediately
                        self.profileImageView.image = image
                        
                        // Update local profile
                        if var profile = self.userProfile {
                            profile.profileImageURL = imageURL
                            self.userProfile = profile
                        }
                        
                        self.showAlert(title: "Success", message: "Profile picture updated successfully!")
                        
                    case .failure(let error):
                        print("❌ Image upload failed: \(error.localizedDescription)")
                        self.showAlert(title: "Upload Failed", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Profile Menu Models
struct ProfileMenuItem {
    let icon: String
    let title: String
    let subtitle: String
    let action: ProfileMenuAction
    var isDestructive: Bool = false
}

enum ProfileMenuAction {
    case editProfile
    case impactSummary
    case changePassword
    case dietPreferences
    case notifications
    case settings
    case terms
    case help
    case logout
}

// MARK: - Profile Menu Cell
class ProfileMenuCell: UITableViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        
        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        containerView.addSubview(iconImageView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 1
        containerView.addSubview(subtitleLabel)
        
        // Chevron
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .lightGray
        chevronImageView.contentMode = .scaleAspectFit
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with menuItem: ProfileMenuItem) {
        iconImageView.image = UIImage(systemName: menuItem.icon)
        titleLabel.text = menuItem.title
        subtitleLabel.text = menuItem.subtitle
        
        if menuItem.isDestructive {
            iconImageView.tintColor = .systemRed
            titleLabel.textColor = .systemRed
        } else {
            iconImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
            titleLabel.textColor = .black
        }
    }
}
