//
//  CollectorProfile.swift
//  DonAte
//
//  Modèle de données pour le profil Collector (Organisation Caritative)
// Conformément aux spécifications du PDF DonAte
//

import Foundation

/// Type d'organisation caritative
enum OrganizationType: String, CaseIterable, Codable {
    case charity = "Charity"
    case communityService = "Community Service"
    case environmentalProtection = "Environmental Protection"
    
    var displayName: String {
        return rawValue
    }
}

/// Jours de la semaine pour la collecte
enum WeekDay: String, CaseIterable, Codable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    static let collectionDays: [WeekDay] = [.sunday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}

/// Fréquence de collecte
enum PickupFrequency: String, CaseIterable, Codable {
    case everyday = "Everyday"
    case weekly = "Weekly"
    
    var displayName: String {
        return rawValue
    }
}

/// Modèle de profil Collector complet
struct CollectorProfile: Codable {
    // MARK: - Identifiants
    var id: String
    var organizationName: String
    var organizationType: OrganizationType
    var registrationNumber: String
    
    // MARK: - Coordonnées
    var contactPerson: String
    var contactEmail: String
    var contactPhoneNumber: String
    var buildingNumber: String
    var poBoxNumber: String
    
    // MARK: - Description
    var description: String
    var website: String?
    
    // MARK: - Vérification
    var isVerified: Bool
    var verificationDocumentURL: String?
    var agreedToTerms: Bool
    
    // MARK: - Planification des collectes
    var pickupFrequency: PickupFrequency
    var pickupDays: [WeekDay]
    var pickupTimeStart: String // Format "HH:mm"
    var pickupTimeEnd: String // Format "HH:mm"
    
    // MARK: - Métadonnées
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Statistiques (calculées dynamiquement)
    var totalDonations: Int
    var totalItemsCollected: Int
    var impactScore: Int
    
    // MARK: - Initialisation
    init() {
        self.id = ""
        self.organizationName = ""
        self.organizationType = .charity
        self.registrationNumber = ""
        self.contactPerson = ""
        self.contactEmail = ""
        self.contactPhoneNumber = ""
        self.buildingNumber = ""
        self.poBoxNumber = ""
        self.description = ""
        self.website = nil
        self.isVerified = false
        self.verificationDocumentURL = nil
        self.agreedToTerms = false
        self.pickupFrequency = .weekly
        self.pickupDays = []
        self.pickupTimeStart = "06:00"
        self.pickupTimeEnd = "17:00"
        self.createdAt = Date()
        self.updatedAt = Date()
        self.totalDonations = 0
        self.totalItemsCollected = 0
        self.impactScore = 0
    }
    
    init(id: String, organizationName: String, organizationType: OrganizationType, registrationNumber: String,
         contactPerson: String, contactEmail: String, contactPhoneNumber: String, buildingNumber: String,
         poBoxNumber: String, description: String, website: String?, isVerified: Bool,
         verificationDocumentURL: String?, agreedToTerms: Bool, pickupFrequency: PickupFrequency,
         pickupDays: [WeekDay], pickupTimeStart: String, pickupTimeEnd: String,
         createdAt: Date, updatedAt: Date, totalDonations: Int, totalItemsCollected: Int, impactScore: Int) {
        self.id = id
        self.organizationName = organizationName
        self.organizationType = organizationType
        self.registrationNumber = registrationNumber
        self.contactPerson = contactPerson
        self.contactEmail = contactEmail
        self.contactPhoneNumber = contactPhoneNumber
        self.buildingNumber = buildingNumber
        self.poBoxNumber = poBoxNumber
        self.description = description
        self.website = website
        self.isVerified = isVerified
        self.verificationDocumentURL = verificationDocumentURL
        self.agreedToTerms = agreedToTerms
        self.pickupFrequency = pickupFrequency
        self.pickupDays = pickupDays
        self.pickupTimeStart = pickupTimeStart
        self.pickupTimeEnd = pickupTimeEnd
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.totalDonations = totalDonations
        self.totalItemsCollected = totalItemsCollected
        self.impactScore = impactScore
    }
    
    // MARK: - Méthodes de validation
    
    /// Valide l'inscription complète
    func validateRegistration() -> (isValid: Bool, errorMessage: String?) {
        if organizationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le nom de l'organisation est requis")
        }
        
        if contactPerson.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le nom du contact est requis")
        }
        
        if !isValidEmail(contactEmail) {
            return (false, "Veuillez entrer une adresse email valide")
        }
        
        if contactPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le numéro de téléphone est requis")
        }
        
        if buildingNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le numéro de bâtiment est requis")
        }
        
        if poBoxNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "La boîte postale est requise")
        }
        
        if registrationNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le numéro d'enregistrement est requis")
        }
        
        if !agreedToTerms {
            return (false, "Vous devez accepter les conditions générales")
        }
        
        if pickupDays.isEmpty {
            return (false, "Veuillez sélectionner au moins un jour de collecte")
        }
        
        return (true, nil)
    }
    
    /// Valide la mise à jour du profil
    func validateProfileUpdate() -> (isValid: Bool, errorMessage: String?) {
        if organizationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le nom de l'organisation est requis")
        }
        
        if contactPerson.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le nom du contact est requis")
        }
        
        if !isValidEmail(contactEmail) {
            return (false, "Veuillez entrer une adresse email valide")
        }
        
        if contactPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return (false, "Le numéro de téléphone est requis")
        }
        
        return (true, nil)
    }
    
    /// Valide le mot de passe (minimum 8 caractères)
    func validatePassword(_ password: String, confirmPassword: String) -> (isValid: Bool, errorMessage: String?) {
        if password.count < 8 {
            return (false, "Le mot de passe doit contenir au moins 8 caractères")
        }
        
        if password != confirmPassword {
            return (false, "Les mots de passe ne correspondent pas")
        }
        
        return (true, nil)
    }
    
    // MARK: - Méthodes utilitaires
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Retourne l'adresse complète
    var fullAddress: String {
        var addressComponents: [String] = []
        
        if !buildingNumber.isEmpty {
            addressComponents.append("Bâtiment: \(buildingNumber)")
        }
        
        if !poBoxNumber.isEmpty {
            addressComponents.append("BP: \(poBoxNumber)")
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    /// Retourne les jours de collecte formatés
    var formattedPickupDays: String {
        if pickupDays.isEmpty {
            return "Aucun jour sélectionné"
        }
        
        let dayNames = pickupDays.map { $0.shortName }
        return dayNames.joined(separator: ", ")
    }
    
    /// Retourne les statistiques formatées
    var impactSummary: String {
        return "\(totalDonations) dons • \(totalItemsCollected) articles • \(impactScore) impact"
    }
    
    // MARK: - Conversion
    
    /// Convertit en dictionnaire pour le stockage
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "organizationName": organizationName,
            "organizationType": organizationType.rawValue,
            "registrationNumber": registrationNumber,
            "contactPerson": contactPerson,
            "contactEmail": contactEmail,
            "contactPhoneNumber": contactPhoneNumber,
            "buildingNumber": buildingNumber,
            "poBoxNumber": poBoxNumber,
            "description": description,
            "website": website ?? "",
            "isVerified": isVerified,
            "verificationDocumentURL": verificationDocumentURL ?? "",
            "agreedToTerms": agreedToTerms,
            "pickupFrequency": pickupFrequency.rawValue,
            "pickupDays": pickupDays.map { $0.rawValue },
            "pickupTimeStart": pickupTimeStart,
            "pickupTimeEnd": pickupTimeEnd,
            "createdAt": createdAt.timeIntervalSince1970,
            "updatedAt": updatedAt.timeIntervalSince1970,
            "totalDonations": totalDonations,
            "totalItemsCollected": totalItemsCollected,
            "impactScore": impactScore
        ]
        return dict
    }
    
    /// Crée un profil à partir d'un dictionnaire
    static func fromDictionary(_ dictionary: [String: Any]) -> CollectorProfile {
        let profile = CollectorProfile()
        
        if let id = dictionary["id"] as? String { profile.id = id }
        if let organizationName = dictionary["organizationName"] as? String { profile.organizationName = organizationName }
        if let orgTypeString = dictionary["organizationType"] as? String {
            profile.organizationType = OrganizationType(rawValue: orgTypeString) ?? .charity
        }
        if let registrationNumber = dictionary["registrationNumber"] as? String { profile.registrationNumber = registrationNumber }
        if let contactPerson = dictionary["contactPerson"] as? String { profile.contactPerson = contactPerson }
        if let contactEmail = dictionary["contactEmail"] as? String { profile.contactEmail = contactEmail }
        if let contactPhoneNumber = dictionary["contactPhoneNumber"] as? String { profile.contactPhoneNumber = contactPhoneNumber }
        if let buildingNumber = dictionary["buildingNumber"] as? String { profile.buildingNumber = buildingNumber }
        if let poBoxNumber = dictionary["poBoxNumber"] as? String { profile.poBoxNumber = poBoxNumber }
        if let description = dictionary["description"] as? String { profile.description = description }
        if let website = dictionary["website"] as? String, !website.isEmpty { profile.website = website }
        if let isVerified = dictionary["isVerified"] as? Bool { profile.isVerified = isVerified }
        if let verificationDocumentURL = dictionary["verificationDocumentURL"] as? String, !verificationDocumentURL.isEmpty {
            profile.verificationDocumentURL = verificationDocumentURL
        }
        if let agreedToTerms = dictionary["agreedToTerms"] as? Bool { profile.agreedToTerms = agreedToTerms }
        if let frequencyString = dictionary["pickupFrequency"] as? String {
            profile.pickupFrequency = PickupFrequency(rawValue: frequencyString) ?? .weekly
        }
        if let pickupDaysArray = dictionary["pickupDays"] as? [String] {
            profile.pickupDays = pickupDaysArray.compactMap { WeekDay(rawValue: $0) }
        }
        if let pickupTimeStart = dictionary["pickupTimeStart"] as? String { profile.pickupTimeStart = pickupTimeStart }
        if let pickupTimeEnd = dictionary["pickupTimeEnd"] as? String { profile.pickupTimeEnd = pickupTimeEnd }
        if let createdAt = dictionary["createdAt"] as? TimeInterval { profile.createdAt = Date(timeIntervalSince1970: createdAt) }
        if let updatedAt = dictionary["updatedAt"] as? TimeInterval { profile.updatedAt = Date(timeIntervalSince1970: updatedAt) }
        if let totalDonations = dictionary["totalDonations"] as? Int { profile.totalDonations = totalDonations }
        if let totalItemsCollected = dictionary["totalItemsCollected"] as? Int { profile.totalItemsCollected = totalItemsCollected }
        if let impactScore = dictionary["impactScore"] as? Int { profile.impactScore = impactScore }
        
        return profile
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case organizationName
        case organizationType
        case registrationNumber
        case contactPerson
        case contactEmail
        case contactPhoneNumber
        case buildingNumber
        case poBoxNumber
        case description
        case website
        case isVerified
        case verificationDocumentURL
        case agreedToTerms
        case pickupFrequency
        case pickupDays
        case pickupTimeStart
        case pickupTimeEnd
        case createdAt
        case updatedAt
        case totalDonations
        case totalItemsCollected
        case impactScore
    }
}
