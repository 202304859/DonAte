import Foundation

// MARK: - Contributor Model
struct Contributor: Codable, Identifiable {
    let id: String
    var username: String
    var firstName: String
    var lastName: String
    var donorBadge: String
    var totalDonations: Int
    var foodTypes: FoodTypesBreakdown
    var previousDonations: [String]
    var donationDays: [String]?
    var donationTime: String?
    var foodGroup: String?
    var status: String?
    var donationNumber: String?
    
    struct FoodTypesBreakdown: Codable {
        var beverages: Int
        var snacksSweets: Int
        var bakedGoods: Int
        var meals: Int
        
        var total: Int {
            return beverages + snacksSweets + bakedGoods + meals
        }
        
        var chartData: [(name: String, value: Int, color: String)] {
            return [
                ("Beverages", beverages, "b4e7b4"),      // Green
                ("Snacks/Sweets", snacksSweets, "FF6B6B"),  // Red
                ("Baked Goods", bakedGoods, "FFA726"),      // Orange
                ("Meals", meals, "42A5F5")                  // Blue
            ]
        }
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var badgeEmoji: String {
        switch donorBadge.lowercased() {
        case let badge where badge.contains("bronze"):
            return "🥉"
        case let badge where badge.contains("silver"):
            return "🥈"
        case let badge where badge.contains("gold"):
            return "🥇"
        case let badge where badge.contains("platinum"):
            return "⭐"
        default:
            return "🎖️"
        }
    }
    
    init(id: String = UUID().uuidString,
         username: String,
         firstName: String,
         lastName: String,
         donorBadge: String,
         totalDonations: Int,
         foodTypes: FoodTypesBreakdown,
         previousDonations: [String] = [],
         donationDays: [String]? = nil,
         donationTime: String? = nil,
         foodGroup: String? = nil,
         status: String? = nil,
         donationNumber: String? = nil) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.donorBadge = donorBadge
        self.totalDonations = totalDonations
        self.foodTypes = foodTypes
        self.previousDonations = previousDonations
        self.donationDays = donationDays
        self.donationTime = donationTime
        self.foodGroup = foodGroup
        self.status = status
        self.donationNumber = donationNumber
    }
}

// MARK: - Sample Data
extension Contributor {
    static func sampleData() -> [Contributor] {
        return [
            Contributor(
                username: "Ali_7786",
                firstName: "Ali",
                lastName: "Jasim",
                donorBadge: "Bronze Donor",
                totalDonations: 164,
                foodTypes: FoodTypesBreakdown(
                    beverages: 45,
                    snacksSweets: 38,
                    bakedGoods: 42,
                    meals: 39
                ),
                previousDonations: ["#13", "#14", "#15"]
            ),
            Contributor(
                username: "Asmaa_12",
                firstName: "Asmaa",
                lastName: "AlAli",
                donorBadge: "Silver Donor",
                totalDonations: 250,
                foodTypes: FoodTypesBreakdown(
                    beverages: 65,
                    snacksSweets: 55,
                    bakedGoods: 70,
                    meals: 60
                ),
                previousDonations: ["#10", "#11", "#12"]
            ),
            Contributor(
                username: "Mohammed_A",
                firstName: "Mohammed",
                lastName: "Ali",
                donorBadge: "Gold Donor",
                totalDonations: 380,
                foodTypes: FoodTypesBreakdown(
                    beverages: 90,
                    snacksSweets: 95,
                    bakedGoods: 100,
                    meals: 95
                ),
                previousDonations: ["#7", "#8", "#9"]
            )
        ]
    }
}
