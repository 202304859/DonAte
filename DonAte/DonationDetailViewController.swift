import Foundation
import UIKit

class DonationDetailViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var scrollView: UIScrollView!
    private var contentStackView: UIStackView!
    
    var donation: Donation!
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        displayDonationDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        title = "Donation Details"
        
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content Stack View
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func displayDonationDetails() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Donation number header
        let numberLabel = UILabel()
        numberLabel.text = "#\(donation.donationNumber)"
        numberLabel.font = .boldSystemFont(ofSize: 28)
        numberLabel.textAlignment = .center
        numberLabel.textColor = .donateGreen
        contentStackView.addArrangedSubview(numberLabel)
        
        // Donor info
        addField(title: "Donor Username", value: donation.donorUsername, highlighted: true)
        addField(title: "Donor Name", value: donation.donorName)
        
        // Food details
        addField(title: "Food Name", value: donation.foodName)
        addField(title: "Description", value: donation.description)
        addField(title: "Food Group", value: donation.foodGroup)
        addField(title: "Food Type", value: donation.foodType)
        addField(title: "Food Storage", value: donation.foodStorage)
        
        // Date & Time
        addField(title: "Date", value: donation.date)
        addField(title: "Time", value: donation.time)
        addField(title: "Quantity", value: "\(donation.quantity)")
        
        // Current status
        addField(title: "Current Status", value: donation.status.rawValue.uppercased(), highlighted: true)
        
        // Buttons
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        
        let updateButton = createButton(title: "Update Status", color: .donateGreen)
        updateButton.addTarget(self, action: #selector(updateStatusTapped), for: .touchUpInside)
        buttonStack.addArrangedSubview(updateButton)
        
        let messageButton = createButton(title: "Message Donor", color: .donateGreen)
        messageButton.addTarget(self, action: #selector(messageDonorTapped), for: .touchUpInside)
        buttonStack.addArrangedSubview(messageButton)
        
        contentStackView.addArrangedSubview(buttonStack)
    }
    
    private func addField(title: String, value: String, highlighted: Bool = false) {
        let container = UIView()
        container.backgroundColor = highlighted ? UIColor.donateGreen.withAlphaComponent(0.1) : .white
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray5.cgColor
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.numberOfLines = 0
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        contentStackView.addArrangedSubview(container)
    }
    
    private func createButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    @objc private func updateStatusTapped() {
        showUpdateStatusModal()
    }
    
    private func showUpdateStatusModal() {
        let alert = UIAlertController(title: "Update Status", message: "Choose new status", preferredStyle: .actionSheet)
        
        let statuses: [Donation.DonationStatus] = [.onTheWay, .collected, .completed]
        
        for status in statuses {
            alert.addAction(UIAlertAction(title: status.rawValue, style: .default) { [weak self] _ in
                self?.updateStatus(to: status)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(alert, animated: true)
    }
    
    private func updateStatus(to status: Donation.DonationStatus) {
        dataManager.updateDonationStatus(id: donation.id, status: status)
        donation.status = status
        
        let alert = UIAlertController(
            title: "✅ Success!",
            message: "Status updated to \(status.rawValue)!\nGo back to dashboard - stats updated!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.displayDonationDetails()
        })
        present(alert, animated: true)
    }
    
    @objc private func messageDonorTapped() {
        let conversationId = dataManager.createConversation(
            with: donation.donorUsername,
            donorName: donation.donorName
        )
        
        let vc = ChatViewController()
        vc.conversationId = conversationId
        vc.donorUsername = donation.donorUsername
        navigationController?.pushViewController(vc, animated: true)
    }
}
