//
//  Address.swift
//  DonAte
//
//  Created by BP-36-213-18 on 03/01/2026.
//

import Foundation

struct Address {

    let addressId: String
    let addressName: String
    let addressPhone: Int
    let blockNo: Int
    let houseNo: Int
    let roadNo: Int
    let townCity: String

    init?(dictionary: [String: Any]) {
        guard
            let addressId = dictionary["addressId"] as? String,
            let addressName = dictionary["addressName"] as? String,
            let addressPhone = dictionary["addressPhone"] as? Int,
            let blockNo = dictionary["blockNo"] as? Int,
            let houseNo = dictionary["houseNo"] as? Int,
            let roadNo = dictionary["roadNo"] as? Int,
            let townCity = dictionary["townCity"] as? String
        else { return nil }

        self.addressId = addressId
        self.addressName = addressName
        self.addressPhone = addressPhone
        self.blockNo = blockNo
        self.houseNo = houseNo
        self.roadNo = roadNo
        self.townCity = townCity
    }
}

