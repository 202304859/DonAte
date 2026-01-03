//
//  Food.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation

struct Food {

    let foodName: String
    let description: String
    let foodType: FoodType
    let foodStorage: FoodStorageType
    let foodGroup: [FoodGroup]
    let dietaryDetails: [DietaryDetail]

    let cookingTemp: String
    let servingTemp: String
    let storageTemp: String
    let quantity: String

    init?(dictionary: [String: Any]) {

        guard
            let foodName = dictionary["foodName"] as? String,
            let description = dictionary["description"] as? String,
            let foodTypeRaw = dictionary["foodType"] as? String,
            let foodStorageRaw = dictionary["foodStorage"] as? String,
            let foodGroupRaw = dictionary["foodGroup"] as? [String],
            let dietaryRaw = dictionary["dietaryDetails"] as? [String],
            let cookingTemp = dictionary["cookingTemp"] as? String,
            let servingTemp = dictionary["servingTemp"] as? String,
            let storageTemp = dictionary["storageTemp"] as? String,
            let quantity = dictionary["quantity"] as? String,

            let foodType = FoodType(rawValue: foodTypeRaw),
            let foodStorage = FoodStorageType(rawValue: foodStorageRaw)
        else {
            return nil
        }

        self.foodName = foodName
        self.description = description
        self.foodType = foodType
        self.foodStorage = foodStorage
        self.foodGroup = foodGroupRaw.compactMap { FoodGroup(rawValue: $0) }
        self.dietaryDetails = dietaryRaw.compactMap { DietaryDetail(rawValue: $0) }
        self.cookingTemp = cookingTemp
        self.servingTemp = servingTemp
        self.storageTemp = storageTemp
        self.quantity = quantity
    }
}

