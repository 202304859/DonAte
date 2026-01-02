import Foundation
import UIKit

class MessagesViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var headerView: UIView!
    private var filterButtonsStackView: UIStackView!
    private var tableView: UITableView!
    
    private var conversations: [Conversation] = []
    private var currentFilter = "All"
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        setupFilterButtons()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadConversations()
    }
    
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        
        // Header View
        headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "b4e7b4")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Messages"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Filter Stack View
        filterButtonsStackView = UIStackView()
        filterButtonsStackView.axis = .horizontal
        filterButtonsStackView.spacing = 12
        filterButtonsStackView.distribution = .fillEqually
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButtonsStackView)
        
        // Table View
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Header View - extends from very top of screen behind status bar
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Make header extend well below safe area for a spacious look
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            
            // Add more top spacing for modern breathable feel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            filterButtonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            filterButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButtonsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: filterButtonsStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupFilterButtons() {
        let filters = ["All", "Admin", "Donor"]
        filterButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for filter in filters {
            let button = FilterButton()
            button.setTitle(filter, for: .normal)
            button.isSelected = filter == "All"
            button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
            filterButtonsStackView.addArrangedSubview(button)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
    }
    
    private func loadConversations() {
        conversations = dataManager.getConversations(filter: currentFilter)
        tableView.reloadData()
    }
    
    @objc private func filterTapped(_ sender: FilterButton) {
        filterButtonsStackView.arrangedSubviews.forEach {
            ($0 as? FilterButton)?.isSelected = false
        }
        sender.isSelected = true
        currentFilter = sender.titleLabel?.text ?? "All"
        loadConversations()
    }
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.configure(with: conversations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = conversations[indexPath.row]
        let vc = ChatViewController()
        vc.conversationId = conversation.id
        vc.donorUsername = conversation.participantName
        navigationController?.pushViewController(vc, animated: true)
    }
}

class ConversationCell: UITableViewCell {
    
    private let cardView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let unreadBadge = UILabel()
    
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
        
        profileImageView.backgroundColor = .donateGreen
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .center
        cardView.addSubview(profileImageView)
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        cardView.addSubview(nameLabel)
        
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 1
        cardView.addSubview(messageLabel)
        
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        cardView.addSubview(timeLabel)
        
        unreadBadge.font = .boldSystemFont(ofSize: 12)
        unreadBadge.textColor = .white
        unreadBadge.backgroundColor = .donateGreen
        unreadBadge.layer.cornerRadius = 10
        unreadBadge.clipsToBounds = true
        unreadBadge.textAlignment = .center
        cardView.addSubview(unreadBadge)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, profileImageView, nameLabel, messageLabel, timeLabel, unreadBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            timeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            unreadBadge.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            unreadBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            unreadBadge.widthAnchor.constraint(equalToConstant: 20),
            unreadBadge.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with conversation: Conversation) {
        nameLabel.text = conversation.participantName
        messageLabel.text = conversation.lastMessage
        timeLabel.text = conversation.formattedTime
        
        let initialsLabel = UILabel()
        initialsLabel.text = String(conversation.participantName.prefix(1)).uppercased()
        initialsLabel.font = .boldSystemFont(ofSize: 20)
        initialsLabel.textColor = .white
        initialsLabel.textAlignment = .center
        initialsLabel.frame = profileImageView.bounds
        initialsLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        profileImageView.subviews.forEach { $0.removeFromSuperview() }
        profileImageView.addSubview(initialsLabel)
        
        if conversation.unreadCount > 0 {
            unreadBadge.text = "\(conversation.unreadCount)"
            unreadBadge.isHidden = false
            timeLabel.isHidden = true
        } else {
            unreadBadge.isHidden = true
            timeLabel.isHidden = false
        }
    }
}
