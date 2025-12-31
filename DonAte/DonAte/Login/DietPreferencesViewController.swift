//
//  DietPreferencesViewController.swift
//  DonAte
//
//  Created by Claude on 30/12/2025.
//

import UIKit

class DietPreferencesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var addAllergyButton: UIButton!
    @IBOutlet weak var allergiesCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var userProfile: UserProfile?
    private var selectedDietPreferences: Set<DietPreference> = []
    private var allergies: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
        loadCurrentPreferences()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Diet Preferences"
        
        // Configure buttons
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
        cancelButton.setTitleColor(UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0), for: .normal)
        
        addAllergyButton.layer.cornerRadius = 20
        addAllergyButton.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        
        // Configure text field
        allergiesTextField.placeholder = "Enter allergy (e.g., Peanuts)"
        allergiesTextField.borderStyle = .roundedRect
        allergiesTextField.layer.cornerRadius = 8
        allergiesTextField.layer.borderWidth = 1
        allergiesTextField.layer.borderColor = UIColor.lightGray.cgColor
        allergiesTextField.delegate = self
        
        activityIndicator.isHidden = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DietPreferenceCell.self, forCellReuseIdentifier: "DietPreferenceCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        allergiesCollectionView.collectionViewLayout = layout
        allergiesCollectionView.delegate = self
        allergiesCollectionView.dataSource = self
        allergiesCollectionView.register(AllergyTagCell.self, forCellWithReuseIdentifier: "AllergyTagCell")
        allergiesCollectionView.backgroundColor = .clear
    }
    
    private func loadCurrentPreferences() {
        guard let profile = userProfile else { return }
        
        selectedDietPreferences = Set(profile.dietPreferences)
        allergies = profile.allergies
        
        tableView.reloadData()
        allergiesCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        savePreferences()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addAllergyButtonTapped(_ sender: UIButton) {
        addAllergy()
    }
    
    private func addAllergy() {
        guard let allergyText = allergiesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !allergyText.isEmpty else {
            return
        }
        
        if !allergies.contains(allergyText) {
            allergies.append(allergyText)
            allergiesCollectionView.reloadData()
            allergiesTextField.text = ""
            allergiesTextField.resignFirstResponder()
        } else {
            showAlert(title: "Duplicate", message: "This allergy is already added")
        }
    }
    
    private func removeAllergy(at index: Int) {
        allergies.remove(at: index)
        allergiesCollectionView.reloadData()
    }
    
    // MARK: - Save Preferences
    private func savePreferences() {
        guard var profile = userProfile else { return }
        
        // Update profile
        profile.dietPreferences = Array(selectedDietPreferences)
        profile.allergies = allergies
        
        // Show loading
        showLoading(true)
        
        // Save to Firebase
        FirebaseManager.shared.updateUserProfile(profile) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showLoading(false)
                
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Diet preferences saved successfully") {
                        self.dismiss(animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to save preferences: \(error.localizedDescription)")
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
}

// MARK: - UITableViewDelegate & DataSource
extension DietPreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DietPreference.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietPreferenceCell", for: indexPath) as! DietPreferenceCell
        let preference = DietPreference.allCases[indexPath.row]
        let isSelected = selectedDietPreferences.contains(preference)
        cell.configure(with: preference, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let preference = DietPreference.allCases[indexPath.row]
        
        if selectedDietPreferences.contains(preference) {
            selectedDietPreferences.remove(preference)
        } else {
            selectedDietPreferences.insert(preference)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension DietPreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allergies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllergyTagCell", for: indexPath) as! AllergyTagCell
        cell.configure(with: allergies[indexPath.item])
        cell.onRemoveTapped = { [weak self] in
            self?.removeAllergy(at: indexPath.item)
        }
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension DietPreferencesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addAllergy()
        return true
    }
}

// MARK: - Diet Preference Cell
class DietPreferenceCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(systemName: "fork.knife")
        iconImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        contentView.addSubview(iconImageView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        // Checkmark
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -10),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with preference: DietPreference, isSelected: Bool) {
        titleLabel.text = preference.rawValue
        checkmarkImageView.isHidden = !isSelected
        
        if isSelected {
            backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 0.1)
            layer.borderWidth = 2
            layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
        } else {
            backgroundColor = .white
            layer.borderWidth = 0
        }
    }
}

// MARK: - Allergy Tag Cell
class AllergyTagCell: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let removeButton = UIButton()
    
    var onRemoveTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 0.2)
        containerView.layer.cornerRadius = 16
        contentView.addSubview(containerView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0)
        containerView.addSubview(titleLabel)
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        containerView.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            removeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20),
            
            containerView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with allergy: String) {
        titleLabel.text = allergy
    }
    
    @objc private func removeTapped() {
        onRemoveTapped?()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 32)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return layoutAttributes
    }
}
