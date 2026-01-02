import UIKit
import Foundation

class ChatViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var scrollView: UIScrollView!
    private var messagesStackView: UIStackView!
    private var messageTextField: UITextField!
    private var sendButton: UIButton!
    private var inputContainerView: UIView!
    
    var conversationId: String = ""
    var donorUsername: String = ""
    
    private var conversation: Conversation?
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set status bar background color
        statusBarBackgroundColor = UIColor(hex: "b4e7b4")
        
        createUI()
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func createUI() {
        view.backgroundColor = .white
        title = "Chat with \(donorUsername)"
        
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Messages Stack View
        messagesStackView = UIStackView()
        messagesStackView.axis = .vertical
        messagesStackView.spacing = 8
        messagesStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messagesStackView)
        
        // Input Container
        inputContainerView = UIView()
        inputContainerView.backgroundColor = .systemGray6
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainerView)
        
        // Text Field
        messageTextField = UITextField()
        messageTextField.placeholder = "Write Message..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.delegate = self
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(messageTextField)
        
        // Send Button
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .donateGreen
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            
            messagesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            messagesStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messagesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            messagesStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            messagesStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            messageTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 70),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addHeader()
    }
    
    private func addHeader() {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.donateGreen.withAlphaComponent(0.1)
        
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 4
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = donorUsername
        nameLabel.font = .boldSystemFont(ofSize: 18)
        
        let typeLabel = UILabel()
        typeLabel.text = "Donor"
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .secondaryLabel
        
        headerStack.addArrangedSubview(nameLabel)
        headerStack.addArrangedSubview(typeLabel)
        
        headerView.addSubview(headerStack)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        messagesStackView.insertArrangedSubview(headerView, at: 0)
    }
    
    private func loadMessages() {
        conversation = dataManager.getConversation(id: conversationId)
        displayMessages()
    }
    
    private func displayMessages() {
        while messagesStackView.arrangedSubviews.count > 1 {
            messagesStackView.arrangedSubviews.last?.removeFromSuperview()
        }
        
        guard let messages = conversation?.messages else { return }
        
        for message in messages {
            let bubbleView = createMessageBubble(message: message)
            messagesStackView.addArrangedSubview(bubbleView)
        }
        
        scrollToBottom()
    }
    
    private func createMessageBubble(message: Message) -> UIView {
        guard !message.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return UIView()
        }
        
        let isFromMe = message.senderType == .collector
        
        let container = UIView()
        
        let bubbleView = UIView()
        bubbleView.backgroundColor = message.bubbleColor
        bubbleView.layer.cornerRadius = 16
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message.text
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = isFromMe ? .white : .black
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView.addSubview(messageLabel)
        container.addSubview(bubbleView)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            
            bubbleView.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        if isFromMe {
            bubbleView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        } else {
            bubbleView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        }
        
        return container
    }
    
    @objc private func sendTapped() {
        sendMessage()
    }
    
    private func sendMessage() {
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespaces),
              !text.isEmpty else { return }
        
        dataManager.sendMessage(conversationId: conversationId, text: text)
        messageTextField.text = ""
        
        loadMessages()
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(x: 0, y: max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height))
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
