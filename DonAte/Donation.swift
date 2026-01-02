import Foundation
import UIKit

// MARK: - Donation Model
struct Donation: Codable, Identifiable {
    let id: String
    var donationNumber: String
    var donorName: String
    var donorUsername: String
    var foodName: String
    var description: String
    var foodGroup: String
    var foodType: String
    var foodStorage: String
    var cookingTemp: String?
    var servingTemp: String?
    var storageTemp: String?
    var date: String
    var time: String
    var quantity: Int
    var status: DonationStatus
    var items: [DonationItem]
    var createdAt: Date
    var collectorId: String?
    var acceptedAt: Date?
    var completedAt: Date?
    var productionDate: String?
    var expiryDate: String?
    var dietaryDetails: String?
    var imageURL: String?
    
    enum DonationStatus: String, Codable {
        case pending = "Pending"
        case accepted = "Accepted"
        case onTheWay = "On The Way"
        case collected = "Collected"
        case delivered = "Delivered"
        case completed = "Completed"
    }
    
    struct DonationItem: Codable {
        let name: String
        let quantity: Int
        let weight: Double
        let unit: String
    }
    
    var totalItems: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    var statusColor: UIColor {
        switch status {
        case .pending:
            return UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0) // Orange
        case .accepted, .onTheWay:
            return .donateGreen
        case .collected, .delivered, .completed:
            return UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.0) // Dark green
        }
    }
    
    init(id: String = UUID().uuidString,
         donationNumber: String,
         donorName: String,
         donorUsername: String,
         foodName: String,
         description: String,
         foodGroup: String,
         foodType: String,
         foodStorage: String,
         cookingTemp: String? = nil,
         servingTemp: String? = nil,
         storageTemp: String? = nil,
         date: String,
         time: String,
         quantity: Int,
         status: DonationStatus = .pending,
         items: [DonationItem],
         createdAt: Date = Date(),
         collectorId: String? = nil,
         acceptedAt: Date? = nil,
         completedAt: Date? = nil,
         productionDate: String? = nil,
         expiryDate: String? = nil,
         dietaryDetails: String? = nil,
         imageURL: String? = nil) {
        self.id = id
        self.donationNumber = donationNumber
        self.donorName = donorName
        self.donorUsername = donorUsername
        self.foodName = foodName
        self.description = description
        self.foodGroup = foodGroup
        self.foodType = foodType
        self.foodStorage = foodStorage
        self.cookingTemp = cookingTemp
        self.servingTemp = servingTemp
        self.storageTemp = storageTemp
        self.date = date
        self.time = time
        self.quantity = quantity
        self.status = status
        self.items = items
        self.createdAt = createdAt
        self.collectorId = collectorId
        self.acceptedAt = acceptedAt
        self.completedAt = completedAt
        self.productionDate = productionDate
        self.expiryDate = expiryDate
        self.dietaryDetails = dietaryDetails
        self.imageURL = imageURL
    }
}

// MARK: - Sample Data
extension Donation {
    static func sampleData() -> [Donation] {
        return [
            // Pending donations (for testing accept)
            Donation(
                donationNumber: "11",
                donorName: "Asmaa AlAli",
                donorUsername: "Asmaa_12",
                foodName: "Rice bag",
                description: "White rice bag about 5 kg",
                foodGroup: "Grains",
                foodType: "Groceries",
                foodStorage: "Dry goods",
                date: "February 2023",
                time: "2:00 pm",
                quantity: 5,
                items: [DonationItem(name: "Rice", quantity: 5, weight: 5.0, unit: "kg")]
            ),
            Donation(
                donationNumber: "12",
                donorName: "Fatima Hajj",
                donorUsername: "Fatima_H",
                foodName: "Fresh vegetables",
                description: "Assorted fresh vegetables",
                foodGroup: "Vegetables",
                foodType: "Fresh produce",
                foodStorage: "Refrigerated",
                date: "February 2023",
                time: "10:00 am",
                quantity: 3,
                items: [DonationItem(name: "Vegetables", quantity: 3, weight: 2.5, unit: "kg")]
            ),
            Donation(
                donationNumber: "13",
                donorName: "Yousif Ali",
                donorUsername: "Yousif_Ali",
                foodName: "Canned goods",
                description: "Various canned foods",
                foodGroup: "Canned",
                foodType: "Groceries",
                foodStorage: "Dry goods",
                date: "February 2023",
                time: "3:00 pm",
                quantity: 10,
                items: [DonationItem(name: "Canned", quantity: 10, weight: 8.0, unit: "kg")]
            ),
            Donation(
                donationNumber: "14",
                donorName: "Hassan Rashid",
                donorUsername: "Hassan_R",
                foodName: "Baked goods",
                description: "Fresh bread and pastries",
                foodGroup: "Bakery",
                foodType: "Baked goods",
                foodStorage: "Room temperature",
                date: "February 2023",
                time: "8:00 am",
                quantity: 15,
                items: [DonationItem(name: "Bread", quantity: 15, weight: 3.0, unit: "kg")]
            ),
            
            // Accepted donations (for testing update status)
            Donation(
                donationNumber: "15",
                donorName: "Ali Jasim",
                donorUsername: "Ali_7786",
                foodName: "Beverages",
                description: "Juice boxes and water",
                foodGroup: "Beverages",
                foodType: "Drinks",
                foodStorage: "Room temperature",
                date: "January 2023",
                time: "11:00 am",
                quantity: 20,
                status: .accepted,
                items: [DonationItem(name: "Drinks", quantity: 20, weight: 10.0, unit: "kg")],
                collectorId: "demo_collector",
                acceptedAt: Date().addingTimeInterval(-86400)
            ),
            Donation(
                donationNumber: "16",
                donorName: "Sara Ahmed",
                donorUsername: "Sara_456",
                foodName: "Snacks",
                description: "Chips and cookies",
                foodGroup: "Snacks",
                foodType: "Snacks & sweets",
                foodStorage: "Dry goods",
                date: "January 2023",
                time: "1:00 pm",
                quantity: 12,
                status: .accepted,
                items: [DonationItem(name: "Snacks", quantity: 12, weight: 4.0, unit: "kg")],
                collectorId: "demo_collector",
                acceptedAt: Date().addingTimeInterval(-43200)
            ),
            
            // Completed donations (for stats)
            Donation(
                donationNumber: "17",
                donorName: "Mohammed Ali",
                donorUsername: "Mohammed_A",
                foodName: "Meals",
                description: "Prepared meals",
                foodGroup: "Meals",
                foodType: "Ready meals",
                foodStorage: "Refrigerated",
                date: "January 2023",
                time: "6:00 pm",
                quantity: 25,
                status: .completed,
                items: [DonationItem(name: "Meals", quantity: 25, weight: 15.0, unit: "kg")],
                collectorId: "demo_collector",
                acceptedAt: Date().addingTimeInterval(-172800),
                completedAt: Date().addingTimeInterval(-86400)
            ),
            Donation(
                donationNumber: "18",
                donorName: "Layla Hassan",
                donorUsername: "Layla_H",
                foodName: "Fruits",
                description: "Fresh fruits",
                foodGroup: "Fruits",
                foodType: "Fresh produce",
                foodStorage: "Refrigerated",
                date: "January 2023",
                time: "9:00 am",
                quantity: 10,
                status: .completed,
                items: [DonationItem(name: "Fruits", quantity: 10, weight: 6.0, unit: "kg")],
                collectorId: "demo_collector",
                acceptedAt: Date().addingTimeInterval(-259200),
                completedAt: Date().addingTimeInterval(-172800)
            )
        ]
    }
}
