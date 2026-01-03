//
//  Donation.swift
//  DonAte
//
//  Created by Zahra Almosawi on 03/01/2026.
//

import Foundation

//import FirebaseFirestore

struct Donation {
    let id: String
    let donorId: String
    let donationType: String
    let status: String

   // let dates: DonationDates
    let dietaryDetails: [String]
    //let food: FoodDetails
    let images: [String]
    let pickupDate: Date
   // let pickupAddress: PickupAddress
}
