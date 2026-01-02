import Foundation

// MARK: - Local Data Manager
class DataManager {
    static let shared = DataManager()
    
    private(set) var donations: [Donation]
    private(set) var contributors: [Contributor]
    private(set) var conversations: [Conversation]
    
    private let collectorId = "demo_collector"
    
    private init() {
        // Load sample data
        self.donations = Donation.sampleData()
        self.contributors = Contributor.sampleData()
        self.conversations = Conversation.sampleData()
    }
    
    // MARK: - Dashboard Stats
    
    func getDashboardStats() -> (accepted: Int, completed: Int, activePickups: Int, foodSaved: Int) {
        let accepted = donations.filter { $0.status == .accepted }.count
        let completed = donations.filter { $0.status == .completed }.count
        let activePickups = donations.filter {
            $0.status == .accepted || $0.status == .onTheWay || $0.status == .collected
        }.count
        let foodSaved = donations
            .filter { $0.status == .completed }
            .reduce(0) { $0 + $1.quantity }
        
        return (accepted, completed, activePickups, foodSaved)
    }
    
    // MARK: - Donations
    
    func getAvailableDonations() -> [Donation] {
        return donations.filter { $0.status == .pending }
    }
    
    func getAcceptedDonations() -> [Donation] {
        return donations.filter {
            $0.collectorId == collectorId &&
            ($0.status == .accepted || $0.status == .onTheWay || $0.status == .collected)
        }
    }
    
    func getDonation(id: String) -> Donation? {
        return donations.first { $0.id == id }
    }
    
    func acceptDonation(id: String) {
        if let index = donations.firstIndex(where: { $0.id == id }) {
            donations[index].status = .accepted
            donations[index].collectorId = collectorId
            donations[index].acceptedAt = Date()
            print("✅ Donation \(donations[index].donationNumber) accepted!")
        }
    }
    
    func updateDonationStatus(id: String, status: Donation.DonationStatus) {
        if let index = donations.firstIndex(where: { $0.id == id }) {
            donations[index].status = status
            if status == .completed {
                donations[index].completedAt = Date()
            }
            print("✅ Donation \(donations[index].donationNumber) updated to \(status.rawValue)")
        }
    }
    
    // MARK: - Contributors
    
    func getContributors() -> [Contributor] {
        return contributors.sorted { $0.totalDonations > $1.totalDonations }
    }
    
    func getContributor(username: String) -> Contributor? {
        return contributors.first { $0.username == username }
    }
    
    // MARK: - Messages
    
    func getConversations(filter: String = "All") -> [Conversation] {
        switch filter {
        case "Admin":
            return conversations.filter { $0.participantType == .admin }
        case "Donor":
            return conversations.filter { $0.participantType == .donor }
        default:
            return conversations
        }
    }
    
    func getConversation(id: String) -> Conversation? {
        return conversations.first { $0.id == id }
    }
    
    func sendMessage(conversationId: String, text: String) {
        if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
            let message = Message(
                senderId: collectorId,
                senderName: "You",
                senderType: .collector,
                text: text
            )
            conversations[index].messages.append(message)
            conversations[index].lastMessage = text
            conversations[index].lastMessageTime = Date()
            print("✅ Message sent!")
        }
    }
    
    func createConversation(with donorUsername: String, donorName: String) -> String {
        let conversation = Conversation(
            participantId: donorUsername,
            participantName: donorName,
            participantType: .donor
        )
        conversations.append(conversation)
        return conversation.id
    }
}
