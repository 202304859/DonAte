import UIKit

// MARK: - MessageBubbleView
// Custom view for chat message bubbles (green for sent, pink for received)

class MessageBubbleView: UIView {
    
    // MARK: - UI Components
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    
    // MARK: - Properties
    private var isFromCurrentUser: Bool = false
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    convenience init(message: Message) {
        self.init(frame: .zero)
        configure(with: message)
    }
    
    // MARK: - Setup
    private func setup() {
        // Bubble view
        bubbleView.layer.cornerRadius = 16
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleView)
        
        // Message label
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageLabel)
        
        // Time label
        timeLabel.font = .systemFont(ofSize: 10)
        timeLabel.textColor = .gray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Message label inside bubble
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            
            // Bubble width constraint
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            // Bubble vertical position
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            
            // Time label
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Configuration
    func configure(with message: Message) {
        isFromCurrentUser = message.senderType == .collector
        
        // Set message text
        messageLabel.text = message.text
        
        // Set time
        timeLabel.text = message.formattedTime
        
        // Configure bubble appearance based on sender
        if isFromCurrentUser {
            // Sent message: Green bubble, white text, aligned right
            bubbleView.backgroundColor = .donateGreen
            messageLabel.textColor = .white
            
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        } else {
            // Received message: Pink bubble, black text, aligned left
            bubbleView.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
            messageLabel.textColor = .black
            
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
            ])
        }
    }
}
