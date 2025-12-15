//
//  DonorProfilr.swift
//  DonAte
//
//  Created by BP-36-201-04 on 15/12/2025.
//

import Foundation

class DonorProfilr: Codable {
    var donorUsername: String?
    var donorFirstName: String?
    var donorLastName: String?
    var donorEmail: String?
    var donorPassword: String?
    var donorPhoneNumber: String?
    var donorAddress: String?
    var donorRanks = ["Bronze","Silver","Gold","Platinum"]
    var donationCount : Int?
    //image?
    //donation array of objects from a different class
    
}
