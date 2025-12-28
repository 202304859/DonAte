//
//  CollectorProfile.swift
//  DonAte
//
//  Created by BP-36-201-04 on 03/12/2025.
//

import Foundation
// MARK: - Registration Validation
func validateRegistration() -> (Bool, String) {
    if organizationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "Organization name is required")
    }
    
    if contactPersonName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "Contact person name is required")
    }
    
    if !isValidEmail(email) {
        return (false, "Please enter a valid email address")
    }
    
    if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "Phone number is required")
    }
    
    if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "Address is required")
    }
    
    if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "City is required")
    }
    
    if registrationNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return (false, "Registration number is required")
    }
    
    return (true, "")
}

// MARK: - Profile Update Methods
func updateProfile(with data: [String: Any]) {
    if let organizationName = data["organizationName"] as? String {
        self.organizationName = organizationName
    }
    if let contactPersonName = data["contactPersonName"] as? String {
        self.contactPersonName = contactPersonName
    }
    if let phoneNumber = data["phoneNumber"] as? String {
        self.phoneNumber = phoneNumber
    }
    if let address = data["address"] as? String {
        self.address = address
    }
    if let city = data["city"] as? String {
        self.city = city
    }
    if let description = data["description"] as? String {
        self.description = description
    }
    if let website = data["website"] as? String {
        self.website = website.isEmpty ? nil : website
    }
    self.updatedAt = Date()
}

// MARK: - Helper Methods
private func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
