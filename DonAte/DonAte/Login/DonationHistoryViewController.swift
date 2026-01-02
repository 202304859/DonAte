//
//  DonationHistoryViewController.swift
//  DonAte
//
//  Created to replace Settings screen
//  January 2, 2026
//

import UIKit
import FirebaseFirestore

class DonationHistoryViewController: UIViewController {
    
    // MARK: - UI Properties
    private let tableView = UITableView()
    private let emptyStateView = UIView()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Data Properties
    private var donations: [Donation] = []
    private var userProfile: UserProfile?
    
    // Colors
    private let greenColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
    private let darkGreen = UIColor(red: 116/255, green: 187/255, blue: 109/255, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupEmptyState()
        loadDonationHistory()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Donation History"
        
        // Add green header
        let headerView = UIView()
        headerView.backgroundColor = greenColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DonationHistoryCell.self, forCellReuseIdentifier: "DonationHistoryCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        // Refresh control
        refreshControl.addTarget(self, action: #selector(refreshDonations), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        // Empty state image
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(systemName: "heart.text.square")
        emptyStateImageView.tintColor = .lightGray
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateView.addSubview(emptyStateImageView)
        
        // Empty state label
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "No donations yet\nStart making a difference today!"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.textColor = .gray
        emptyStateView.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadDonationHistory() {
        guard let uid = FirebaseManager.shared.currentUser?.uid else {
            showEmptyState()
            return
        }
        
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        // Fetch user profile first to determine user type
        FirebaseManager.shared.fetchUserProfile(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.userProfile = profile
                self.fetchDonations(for: uid, userType: profile.userType)
            case .failure(let error):
                print("❌ Failed to load profile: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showEmptyState()
                }
            }
        }
    }
    
    private func fetchDonations(for uid: String, userType: UserType) {
        let db = Firestore.firestore()
        
        // Query based on user type
        let query: Query
        if userType == .donor {
            query = db.collection("donations").whereField("donorId", isEqualTo: uid)
        } else {
            query = db.collection("donations").whereField("collectorId", isEqualTo: uid)
        }
        
        query.order(by: "createdAt", descending: true).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                
                if let error = error {
                    print("❌ Error fetching donations: \(error.localizedDescription)")
                    self.showEmptyState()
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("ℹ️ No donations found")
                    self.showEmptyState()
                    return
                }
                
                // Parse donations
                self.donations = documents.compactMap { doc -> Donation? in
                    let data = doc.data()
                    return Donation(id: doc.documentID, data: data)
                }
                
                print("✅ Loaded \(self.donations.count) donations")
                self.tableView.isHidden = false
                self.emptyStateView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func refreshDonations() {
        loadDonationHistory()
    }
    
    private func showEmptyState() {
        tableView.isHidden = true
        emptyStateView.isHidden = false
    }
}

// MARK: - UITableViewDelegate & DataSource
extension DonationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationHistoryCell", for: indexPath) as! DonationHistoryCell
        let donation = donations[indexPath.row]
        cell.configure(with: donation, userType: userProfile?.userType ?? .donor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let donation = donations[indexPath.row]
        showDonationDetails(donation)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func showDonationDetails(_ donation: Donation) {
        let alert = UIAlertController(title: donation.foodType, message: """
            Status: \(donation.status.rawValue)
            Quantity: \(donation.quantity)
            Date: \(formatDate(donation.createdAt))
            \(donation.notes.isEmpty ? "" : "\nNotes: \(donation.notes)")
            """, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Donation Model
struct Donation {
    let id: String
    let foodType: String
    let quantity: String
    let status: DonationStatus
    let createdAt: Date
    let notes: String
    
    init?(id: String, data: [String: Any]) {
        self.id = id
        
        guard let foodType = data["foodType"] as? String,
              let quantity = data["quantity"] as? String,
              let statusString = data["status"] as? String,
              let status = DonationStatus(rawValue: statusString) else {
            return nil
        }
        
        self.foodType = foodType
        self.quantity = quantity
        self.status = status
        self.notes = data["notes"] as? String ?? ""
        
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

enum DonationStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

// MARK: - Donation History Cell
class DonationHistoryCell: UITableViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let foodTypeLabel = UILabel()
    private let quantityLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusBadge = UIView()
    private let statusLabel = UILabel()
    
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
        iconImageView.image = UIImage(systemName: "fork.knife")
        iconImageView.tintColor = UIColor(red: 180/255, green: 231/255, blue: 180/255, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
        
        // Food type
        foodTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        foodTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        foodTypeLabel.textColor = .black
        containerView.addSubview(foodTypeLabel)
        
        // Quantity
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.font = UIFont.systemFont(ofSize: 14)
        quantityLabel.textColor = .gray
        containerView.addSubview(quantityLabel)
        
        // Date
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray
        containerView.addSubview(dateLabel)
        
        // Status badge
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        statusBadge.layer.cornerRadius = 12
        containerView.addSubview(statusBadge)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .white
        statusBadge.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            foodTypeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            foodTypeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            foodTypeLabel.trailingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: -10),
            
            quantityLabel.topAnchor.constraint(equalTo: foodTypeLabel.bottomAnchor, constant: 4),
            quantityLabel.leadingAnchor.constraint(equalTo: foodTypeLabel.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: foodTypeLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: foodTypeLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: foodTypeLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            statusBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(with donation: Donation, userType: UserType) {
        foodTypeLabel.text = donation.foodType
        quantityLabel.text = "Quantity: \(donation.quantity)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: donation.createdAt)
        
        statusLabel.text = donation.status.rawValue
        
        switch donation.status {
        case .pending:
            statusBadge.backgroundColor = .systemOrange
        case .accepted:
            statusBadge.backgroundColor = .systemBlue
        case .completed:
            statusBadge.backgroundColor = .systemGreen
        case .cancelled:
            statusBadge.backgroundColor = .systemRed
        }
    }
}
