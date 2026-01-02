//
//  ProfileViewController.swift
//  DonAte
//
//  ✅ WORKING: Correctly loads EditProfileViewController from Login.storyboard
//  ✅ UPDATED: Added Organization Details + Replaced Settings with Donation History
//  Updated: January 2, 2026
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
    private let logoImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGreenHeader()
        addLogoToHeader()
        setupUI()
        setupTableView()
        loadUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
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
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0).cgColor
        profileImageView.contentMode = .scaleAspectFill
        
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.backgroundColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        
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
        // ✅ SECTION 1: Profile Management - Added Organization Details for collectors
        var section1 = [
            ProfileMenuItem(icon: "person.fill", title: "Edit Profile", subtitle: "Update your personal information", action: .editProfile),
            ProfileMenuItem(icon: "chart.bar.fill", title: "Impact Summary", subtitle: "View your donation statistics", action: .impactSummary),
            ProfileMenuItem(icon: "lock.fill", title: "Change Password", subtitle: "Update your password", action: .changePassword)
        ]
        
        // Add Organization Details only for collectors
        if userProfile?.userType == .collector {
            section1.insert(
                ProfileMenuItem(icon: "building.2.fill", title: "Organization Details", subtitle: "View your organization information", action: .organizationDetails),
                at: 1
            )
        }
        
        // ✅ SECTION 2: Preferences - Replaced Settings with Donation History
        let section2 = [
            ProfileMenuItem(icon: "message.fill", title: "Messages", subtitle: "View and manage your messages", action: .messages),
            ProfileMenuItem(icon: "bell.fill", title: "Notifications", subtitle: "Manage notification settings", action: .notifications),
            ProfileMenuItem(icon: "clock.arrow.circlepath", title: "Donation History", subtitle: "View your past donations", action: .donationHistory)
        ]
        
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
                    // Refresh menu items to show/hide Organization Details
                    self.setupMenuItems()
                    self.tableView.reloadData()
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
        
        if let imageURLString = profile.profileImageURL,
           !imageURLString.isEmpty,
           let imageURL = URL(string: imageURLString) {
            print("🖼️ Loading image from: \(imageURLString)")
            loadImage(from: imageURL)
        } else {
            print("ℹ️ No profile image URL found, using default")
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
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        navigateToEditProfile()
    }
    
    // ✅ PROPER: Load EditProfileViewController from Login.storyboard
    private func navigateToEditProfile() {
        guard let profile = userProfile else {
            showAlert(title: "Error", message: "Profile not loaded")
            return
        }
        
        print("🔄 Loading EditProfileViewController from Login.storyboard...")
        
        // Load from Login.storyboard (where it actually exists)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {
            print("❌ Failed to load EditProfileViewController")
            showAlert(title: "Error", message: "Could not load edit profile screen")
            return
        }
        
        // Pass the profile data
        editVC.userProfile = profile
        
        print("✅ Successfully loaded EditProfileViewController")
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "Profile Picture", message: "Choose an option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    
    private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func handleMenuAction(_ action: ProfileMenuAction) {
        switch action {
        case .editProfile:
            navigateToEditProfile()
            
        case .impactSummary:
            let impactVC = ImpactSummaryViewController()
            impactVC.userProfile = userProfile
            navigationController?.pushViewController(impactVC, animated: true)
            
        case .changePassword:
            let changePasswordVC = ChangePasswordViewController()
            navigationController?.pushViewController(changePasswordVC, animated: true)
            
        case .organizationDetails:
            let orgVC = OrganizationDetailsViewController()
            orgVC.userProfile = userProfile
            navigationController?.pushViewController(orgVC, animated: true)
            
        case .messages:
            showComingSoon(feature: "Messages")
            
        case .notifications:
            showComingSoon(feature: "Notifications")
            
        case .donationHistory:
            let historyVC = DonationHistoryViewController()
            navigationController?.pushViewController(historyVC, animated: true)
            
        case .terms:
            let termsVC = TermsOfServiceViewController()
            navigationController?.pushViewController(termsVC, animated: true)
            
        case .help:
            showComingSoon(feature: "Help & Support")
            
        case .logout:
            handleLogout()
        }
    }
    
    private func handleLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            FirebaseManager.shared.logoutUser { error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.dismiss(animated: true)
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showComingSoon(feature: String) {
        let alert = UIAlertController(title: "Coming Soon", message: "\(feature) feature is coming soon!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        return 76
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
                        print("✅ Image upload complete, URL: \(imageURL)")
                        self.profileImageView.image = image
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
    case organizationDetails  // ✅ NEW
    case messages
    case notifications
    case donationHistory      // ✅ REPLACES .settings
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
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
        containerView.addSubview(iconImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 1
        containerView.addSubview(subtitleLabel)
        
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
            iconImageView.tintColor = UIColor(red: 0.706, green: 0.906, blue: 0.706, alpha: 1.0)
            titleLabel.textColor = .black
        }
    }
}
