//
//  User.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation
import FirebaseFirestore

struct User {

    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let phone: Int

    let role: UserRole
    let status: UserStatus
    let points: Int
    let dateJoined: Date
    let addresses: [Address]

    init?(id: String, dictionary: [String: Any]) {

        guard
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String,
            let phone = dictionary["phone"] as? Int,
            let roleRaw = dictionary["role"] as? String,
            let statusRaw = dictionary["status"] as? String,
            let points = dictionary["points"] as? Int,
            let joinedTS = dictionary["dateJoined"] as? Timestamp,
            let addressArray = dictionary["address"] as? [[String: Any]],
            let role = UserRole(rawValue: roleRaw),
            let status = UserStatus(rawValue: statusRaw)
        else { return nil }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.phone = phone
        self.role = role
        self.status = status
        self.points = points
        self.dateJoined = joinedTS.dateValue()
        self.addresses = addressArray.compactMap { Address(dictionary: $0) }
    }
}
