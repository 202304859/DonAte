//
//  CloudinaryConfig.swift
//  DonAte
//
//  ✅ FIXED: Correct cloud name
//  Created by Claude on 01/01/2026.
//

import Foundation

struct CloudinaryConfig {
    
    // MARK: - Cloudinary Credentials
    
    /// Your Cloudinary Cloud Name - CORRECTED!
    static let cloudName = "ddlomjt4h"
    
    /// Upload Preset Name (for unsigned uploads)
    static let uploadPreset = "donate_profile_images"
    
    // MARK: - Upload Configuration
    
    /// Folder where profile images will be stored in Cloudinary
    static let profileImagesFolder = "donate_app/profile_images"
    
    /// Maximum file size for uploads (5MB)
    static let maxFileSizeBytes = 5_242_880
    
    /// Allowed image formats
    static let allowedFormats = ["jpg", "jpeg", "png", "heic"]
    
    // MARK: - Image Transformation Presets
    
    /// Transform profile images to 500x500 circular crop
    static let profileImageTransformation = "w_500,h_500,c_fill,g_face,r_max"
    
    /// Transform thumbnail to 150x150
    static let thumbnailTransformation = "w_150,h_150,c_fill,g_face,r_max"
    
    // MARK: - Helper Methods
    
    /// Check if credentials are configured
    static var isConfigured: Bool {
        return !cloudName.isEmpty && !uploadPreset.isEmpty
    }
    
    /// Get base Cloudinary URL
    static var baseURL: String {
        return "https://res.cloudinary.com/\(cloudName)/image/upload/"
    }
    
    /// Get transformed image URL
    static func getTransformedURL(publicId: String, transformation: String) -> String {
        return "\(baseURL)\(transformation)/\(publicId)"
    }
}
