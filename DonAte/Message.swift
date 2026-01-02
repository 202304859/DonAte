import Foundation
import UIKit  

// MARK: - Message Model
struct Message: Codable, Identifiable {
    let id: String
    var senderId: String
    var senderName: String
    var senderType: SenderType
    var text: String
    var timestamp: Date
    var isRead: Bool
    
    enum SenderType: String, Codable {
        case collector = "Collector"
        case donor = "Donor"
        case admin = "Admin"
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: timestamp)
    }
    
    var bubbleColor: UIColor {
        return senderType == .collector ? .donateGreen : UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
    }
    
    init(id: String = UUID().uuidString,
         senderId: String,
         senderName: String,
         senderType: SenderType,
         text: String,
         timestamp: Date = Date(),
         isRead: Bool = false) {
        self.id = id
        self.senderId = senderId
        self.senderName = senderName
        self.senderType = senderType
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

// MARK: - Conversation Model
struct Conversation: Codable, Identifiable {
    let id: String
    var participantId: String
    var participantName: String
    var participantType: Message.SenderType
    var lastMessage: String
    var lastMessageTime: Date
    var unreadCount: Int
    var messages: [Message]
    
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: lastMessageTime, relativeTo: Date())
    }
    
    init(id: String = UUID().uuidString,
         participantId: String,
         participantName: String,
         participantType: Message.SenderType,
         lastMessage: String = "",
         lastMessageTime: Date = Date(),
         unreadCount: Int = 0,
         messages: [Message] = []) {
        self.id = id
        self.participantId = participantId
        self.participantName = participantName
        self.participantType = participantType
        self.lastMessage = lastMessage
        self.lastMessageTime = lastMessageTime
        self.unreadCount = unreadCount
        self.messages = messages
    }
}

// MARK: - Sample Data
extension Conversation {
    static func sampleData() -> [Conversation] {
        let now = Date()
        
        let conv1Messages = [
            Message(senderId: "Asmaa_12", senderName: "Asmaa_12", senderType: .donor, text: "Hi, the donation is ready for pickup!", timestamp: now.addingTimeInterval(-3600)),
            Message(senderId: "demo_collector", senderName: "You", senderType: .collector, text: "Great! I'll be there at 2:00 PM", timestamp: now.addingTimeInterval(-1800)),
            Message(senderId: "Asmaa_12", senderName: "Asmaa_12", senderType: .donor, text: "Perfect, see you then!", timestamp: now.addingTimeInterval(-900))
        ]
        
        let conv2Messages = [
            Message(senderId: "admin_1", senderName: "Admin", senderType: .admin, text: "Your account has been approved!", timestamp: now.addingTimeInterval(-7200))
        ]
        
        return [
            Conversation(
                participantId: "Asmaa_12",
                participantName: "Asmaa_12",
                participantType: .donor,
                lastMessage: "Perfect, see you then!",
                lastMessageTime: now.addingTimeInterval(-900),
                unreadCount: 1,
                messages: conv1Messages
            ),
            Conversation(
                participantId: "admin_1",
                participantName: "Admin",
                participantType: .admin,
                lastMessage: "Your account has been approved!",
                lastMessageTime: now.addingTimeInterval(-7200),
                unreadCount: 0,
                messages: conv2Messages
            )
        ]
    }
}
