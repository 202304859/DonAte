import UIKit

class DonationListViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var segmentedControl: UISegmentedControl!
    private var tableView: UITableView!
    
    // MARK: - Properties
    enum ListType {
        case available
        case accepted
    }
    
    var listType: ListType = .available
    private var donations: [Donation] = []
    private var contributors: [Contributor] = []
    private var showingDonations = true
    private let dataManager = DataManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        setupTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        loadData()
    }
    
    // MARK: - Create UI
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        title = listType == .available ? "Available Requests" : "Accepted Requests"
        
        // Segmented Control
        segmentedControl = UISegmentedControl(items: ["Donation", "Regular Contributor"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // Table View
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DonationListCell.self, forCellReuseIdentifier: "DonationListCell")
        tableView.register(ContributorListCell.self, forCellReuseIdentifier: "ContributorListCell")
    }
    
    private func loadData() {
        if listType == .available {
            donations = dataManager.getAvailableDonations()
            contributors = dataManager.getContributors()
        } else {
            donations = dataManager.getAcceptedDonations()
            contributors = []
        }
        tableView.reloadData()
    }
    
    @objc private func segmentChanged() {
        showingDonations = segmentedControl.selectedSegmentIndex == 0
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension DonationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingDonations ? donations.count : contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showingDonations {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonationListCell", for: indexPath) as! DonationListCell
            cell.configure(with: donations[indexPath.row], showAcceptButton: listType == .available)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorListCell", for: indexPath) as! ContributorListCell
            cell.configure(with: contributors[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if showingDonations {
            let vc = DonationDetailViewController()
            vc.donation = donations[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ContributorDetailViewController()
            vc.contributor = contributors[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - DonationListCell Delegate
extension DonationListViewController: DonationListCellDelegate {
    func didTapAccept(donation: Donation) {
        let alert = UIAlertController(
            title: "Accept Donation",
            message: "Do you want to accept donation #\(donation.donationNumber)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { [weak self] _ in
            self?.acceptDonation(donation)
        })
        
        present(alert, animated: true)
    }
    
    private func acceptDonation(_ donation: Donation) {
        dataManager.acceptDonation(id: donation.id)
        
        let alert = UIAlertController(
            title: "✅ Success!",
            message: "Donation #\(donation.donationNumber) accepted!\nCheck your dashboard - stats updated!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - DonationListCell
protocol DonationListCellDelegate: AnyObject {
    func didTapAccept(donation: Donation)
}

class DonationListCell: UITableViewCell {
    
    weak var delegate: DonationListCellDelegate?
    private var donation: Donation?
    
    private let cardView = UIView()
    private let numberLabel = UILabel()
    private let donorLabel = UILabel()
    private let foodLabel = UILabel()
    private let itemsLabel = UILabel()
    private let statusLabel = UILabel()
    private let acceptButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.donateGreen.cgColor
        contentView.addSubview(cardView)
        
        numberLabel.font = .boldSystemFont(ofSize: 20)
        numberLabel.textAlignment = .center
        cardView.addSubview(numberLabel)
        
        donorLabel.font = .systemFont(ofSize: 14)
        donorLabel.textColor = .gray
        cardView.addSubview(donorLabel)
        
        foodLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cardView.addSubview(foodLabel)
        
        itemsLabel.font = .systemFont(ofSize: 14)
        itemsLabel.textColor = .gray
        cardView.addSubview(itemsLabel)
        
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        cardView.addSubview(statusLabel)
        
        acceptButton.setTitle("Accept Request", for: .normal)
        acceptButton.backgroundColor = .donateGreen
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        acceptButton.layer.cornerRadius = 8
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        cardView.addSubview(acceptButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, numberLabel, donorLabel, foodLabel, itemsLabel, statusLabel, acceptButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            numberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            numberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            numberLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            donorLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8),
            donorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            donorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            foodLabel.topAnchor.constraint(equalTo: donorLabel.bottomAnchor, constant: 8),
            foodLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            foodLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            itemsLabel.topAnchor.constraint(equalTo: foodLabel.bottomAnchor, constant: 4),
            itemsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            statusLabel.centerYAnchor.constraint(equalTo: itemsLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            acceptButton.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor, constant: 12),
            acceptButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            acceptButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            acceptButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            acceptButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with donation: Donation, showAcceptButton: Bool) {
        self.donation = donation
        
        numberLabel.text = "#\(donation.donationNumber)"
        donorLabel.text = "From: \(donation.donorUsername)"
        foodLabel.text = donation.foodName
        itemsLabel.text = "\(donation.totalItems) items • \(donation.quantity) qty"
        statusLabel.text = donation.status.rawValue
        statusLabel.textColor = donation.statusColor
        
        acceptButton.isHidden = !showAcceptButton
    }
    
    @objc private func acceptTapped() {
        guard let donation = donation else { return }
        delegate?.didTapAccept(donation: donation)
    }
}

// MARK: - ContributorListCell
class ContributorListCell: UITableViewCell {
    
    private let cardView = UIView()
    private let usernameLabel = UILabel()
    private let nameLabel = UILabel()
    private let badgeLabel = UILabel()
    private let donationsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.donateGreen.cgColor
        contentView.addSubview(cardView)
        
        usernameLabel.font = .boldSystemFont(ofSize: 18)
        cardView.addSubview(usernameLabel)
        
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .gray
        cardView.addSubview(nameLabel)
        
        badgeLabel.font = .systemFont(ofSize: 12)
        badgeLabel.textColor = .donateGreen
        cardView.addSubview(badgeLabel)
        
        donationsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        donationsLabel.textColor = .donateGreen
        cardView.addSubview(donationsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, usernameLabel, nameLabel, badgeLabel, donationsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: donationsLabel.leadingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            badgeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            badgeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            badgeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            donationsLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            donationsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with contributor: Contributor) {
        usernameLabel.text = contributor.username
        nameLabel.text = contributor.fullName
        badgeLabel.text = "\(contributor.badgeEmoji) \(contributor.donorBadge)"
        donationsLabel.text = "\(contributor.totalDonations)"
    }
}
