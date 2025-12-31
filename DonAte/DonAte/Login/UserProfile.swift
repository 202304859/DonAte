//
//  UserProfile.swift
//  DonAte
//
//  FIXED: Simplified date handling
//  Created by Claude on 30/12/2025.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    var uid: String
    var fullName: String
    var email: String
    var phoneNumber: String?
    var location: String?
    var dateOfBirth: Date?
    var profileImageURL: String?
    var userType: UserType
    
    // Diet Preferences
    var dietPreferences: [DietPreference]
    var allergies: [String]
    
    // Additional Profile Info
    var verificationStatus: Bool
    var registrationDate: Date
    var lastLogin: Date?
    
    // Impact Statistics (for donors)
    var totalDonations: Int
    var totalMealsProvided: Int
    var impactScore: Int
    
    enum CodingKeys: String, CodingKey {
        case uid
        case fullName
        case email
        case phoneNumber
        case location
        case dateOfBirth
        case profileImageURL
        case userType
        case dietPreferences
        case allergies
        case verificationStatus
        case registrationDate
        case lastLogin
        case totalDonations
        case totalMealsProvided
        case impactScore
    }
    
    init(uid: String, fullName: String, email: String, userType: UserType) {
        self.uid = uid
        self.fullName = fullName
        self.email = email
        self.userType = userType
        self.dietPreferences = []
        self.allergies = []
        self.verificationStatus = false
        self.registrationDate = Date()
        self.totalDonations = 0
        self.totalMealsProvided = 0
        self.impactScore = 0
    }
    
    // ✅ FIXED: Simplified decoder - works with secondsSince1970 strategy
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uid = try container.decode(String.self, forKey: .uid)
        fullName = try container.decode(String.self, forKey: .fullName)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        
        // Decode userType
        let userTypeString = try container.decode(String.self, forKey: .userType)
        userType = UserType(rawValue: userTypeString) ?? .donor
        
        // Decode diet preferences
        let dietPreferenceStrings = try container.decode([String].self, forKey: .dietPreferences)
        dietPreferences = dietPreferenceStrings.compactMap { DietPreference(rawValue: $0) }
        
        allergies = try container.decode([String].self, forKey: .allergies)
        verificationStatus = try container.decode(Bool.self, forKey: .verificationStatus)
        totalDonations = try container.decode(Int.self, forKey: .totalDonations)
        totalMealsProvided = try container.decode(Int.self, forKey: .totalMealsProvided)
        impactScore = try container.decode(Int.self, forKey: .impactScore)
        
        // ✅ Dates are now decoded automatically using dateDecodingStrategy
        dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        registrationDate = try container.decode(Date.self, forKey: .registrationDate)
        lastLogin = try container.decodeIfPresent(Date.self, forKey: .lastLogin)
    }
    
    // Convert to Firestore dictionary
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "uid": uid,
            "fullName": fullName,
            "email": email,
            "userType": userType.rawValue,
            "dietPreferences": dietPreferences.map { $0.rawValue },
            "allergies": allergies,
            "verificationStatus": verificationStatus,
            "registrationDate": Timestamp(date: registrationDate),
            "totalDonations": totalDonations,
            "totalMealsProvided": totalMealsProvided,
            "impactScore": impactScore
        ]
        
        if let phoneNumber = phoneNumber {
            dict["phoneNumber"] = phoneNumber
        }
        if let location = location {
            dict["location"] = location
        }
        if let dateOfBirth = dateOfBirth {
            dict["dateOfBirth"] = Timestamp(date: dateOfBirth)
        }
        if let profileImageURL = profileImageURL {
            dict["profileImageURL"] = profileImageURL
        }
        if let lastLogin = lastLogin {
            dict["lastLogin"] = Timestamp(date: lastLogin)
        }
        
        return dict
    }
}

enum UserType: String, Codable {
    case donor = "Donor"
    case collector = "Collector"
    case admin = "Admin"
}

enum DietPreference: String, Codable, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten Free"
    case dairyFree = "Dairy Free"
    case halal = "Halal"
    case kosher = "Kosher"
    case nutFree = "Nut Free"
    case noPreference = "No Preference"
}
