import UIKit

// MARK: - DonationCell
// Custom table view cell for displaying donation cards

class DonationCell: UITableViewCell {
    
    // MARK: - UI Components
    private let cardView = UIView()
    private let numberLabel = UILabel()
    private let itemsLabel = UILabel()
    private let statusLabel = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Configure card view
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.donateGreen.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(cardView)
        
        // Configure number label
        numberLabel.font = .boldSystemFont(ofSize: 18)
        numberLabel.textColor = .black
        cardView.addSubview(numberLabel)
        
        // Configure items label
        itemsLabel.font = .systemFont(ofSize: 14)
        itemsLabel.textColor = .gray
        cardView.addSubview(itemsLabel)
        
        // Configure status label
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        cardView.addSubview(statusLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, numberLabel, itemsLabel, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Card view
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Number label
            numberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Items label
            itemsLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            itemsLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            itemsLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            // Status label
            statusLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    func configure(with donation: Donation) {
        numberLabel.text = "#\(donation.donationNumber)"
        itemsLabel.text = "\(donation.totalItems) items"
        statusLabel.text = donation.status.rawValue
        statusLabel.textColor = donation.statusColor
    }
}
