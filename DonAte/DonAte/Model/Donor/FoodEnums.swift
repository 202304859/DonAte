//
//  FoodEnums.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation

// MARK: - Donation Type
enum DonationType: String {
    case OneTime = "oneTime"
    case Regular = "regular"
}

// MARK: - Donation Status
enum DonationStatus: String {
    case Pending = "pending"
    case Accepted = "accepted"
    case OnTheWay = "on the way"
    case Collected = "collected"
    case Delivered = "delivered"
    case Rejected = "rejected"
}

// MARK: - Dietary Details
enum DietaryDetail: String {
    case Halal = "Halal"
    case Vegan = "Vegan"
    case Vegetarian = "Vegetarian"
}

// MARK: - Food Group
enum FoodGroup: String {
    case Grains = "Grains"
    case Protein = "Protein"
    case Fruits = "Fruits"
    case Vegetables = "Vegetables"
    case MilkAndAlternatives = "Milk and alternatives"
    case OilSaltSugar = "Oil, salt, sugar"
    case Other = "Other"
}

// MARK: - Food Type (Only One)
enum FoodType: String {
    case SideDish = "Side dish"
    case Dessert = "Dessert"
    case Snacks = "Snacks"
    case Beverages = "Beverages"
    case Groceries = "Groceries"
    case BakedGoods = "Baked goods"
    case Other = "Other"
}

// MARK: - Food Storage Type
enum FoodStorageType: String {
    case DryGoods = "Dry goods"
    case Frozen = "Frozen"
    case Canned = "Canned"
    case FreshProduce = "Fresh produce"
    case Prepared = "Prepared"
    case Refrigerated = "Refrigerated"
    case Other = "Other"
}
