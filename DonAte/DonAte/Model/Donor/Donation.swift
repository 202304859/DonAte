//
//  Donation.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation
import FirebaseFirestore

struct Donation {

    let id: String
    let donationType: DonationType
    let donorId: String
    let status: DonationStatus

    let productionDate: Date
    let expirationDate: Date
    let pickupDate: Date

    let images: [String]
    let ngoId: String?
    let ngoName: String?

    let food: Food

    init?(id: String, dictionary: [String: Any]) {

        guard
            let donationTypeRaw = dictionary["donationType"] as? String,
            let donorId = dictionary["donorId"] as? String,
            let statusRaw = dictionary["status"] as? String,

            let productionTS = dictionary["productionDate"] as? Timestamp,
            let expirationTS = dictionary["ExpirationDate"] as? Timestamp,
            let pickupTS = dictionary["pickup"] as? Timestamp,

            let images = dictionary["images"] as? [String],
            let foodDict = dictionary["food"] as? [String: Any],

            let donationType = DonationType(rawValue: donationTypeRaw),
            let status = DonationStatus(rawValue: statusRaw),
            let food = Food(dictionary: foodDict)
        else {
            return nil
        }

        self.id = id
        self.donationType = donationType
        self.donorId = donorId
        self.status = status
        self.productionDate = productionTS.dateValue()
        self.expirationDate = expirationTS.dateValue()
        self.pickupDate = pickupTS.dateValue()
        self.images = images
        self.food = food
        self.ngoId = dictionary["ngoId"] as? String
        self.ngoName = dictionary["ngoName"] as? String
    }
}
