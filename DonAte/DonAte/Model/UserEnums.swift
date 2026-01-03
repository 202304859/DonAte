//
//  UserEnums.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation

enum UserRole: String {
    case Donor = "donor"
    case NGO = "ngo"
    case Admin = "admin"
}

enum UserStatus: String {
    case Active = "active"
    case Inactive = "inactive"
    case Suspended = "suspended"
}
