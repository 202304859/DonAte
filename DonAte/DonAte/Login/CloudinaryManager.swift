//
//  CloudinaryManager.swift
//  DonAte
//
//  ✅ DEBUG VERSION: Detailed error logging
//  Created by Claude on 01/01/2026.
//

import Foundation
import UIKit
import Cloudinary

class CloudinaryManager {
    
    // MARK: - Singleton
    static let shared = CloudinaryManager()
    
    // MARK: - Properties
    private var cloudinary: CLDCloudinary?
    
    // MARK: - Initialization
    private init() {
        setupCloudinary()
    }
    
    // MARK: - Setup
    private func setupCloudinary() {
        guard CloudinaryConfig.isConfigured else {
            print("❌ Cloudinary not configured!")
            return
        }
        
        let config = CLDConfiguration(cloudName: CloudinaryConfig.cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
        
        print("=" * 60)
        print("CLOUDINARY CONFIGURATION")
        print("=" * 60)
        print("Cloud Name: \(CloudinaryConfig.cloudName)")
        print("Upload Preset: \(CloudinaryConfig.uploadPreset)")
        print("Configured: \(CloudinaryConfig.isConfigured)")
        print("=" * 60)
    }
    
    // MARK: - Upload Profile Image
    
    func uploadProfileImage(
        image: UIImage,
        userId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        print("\n" + "=" * 60)
        print("STARTING UPLOAD")
        print("=" * 60)
        
        guard let cloudinary = cloudinary else {
            print("❌ Cloudinary instance is nil")
            completion(.failure(CloudinaryError.notConfigured))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Failed to convert image to JPEG")
            completion(.failure(CloudinaryError.imageConversionFailed))
            return
        }
        
        if imageData.count > CloudinaryConfig.maxFileSizeBytes {
            print("❌ Image too large: \(imageData.count) bytes")
            completion(.failure(CloudinaryError.fileTooLarge))
            return
        }
        
        print("Image size: \(imageData.count) bytes (\(imageData.count / 1024) KB)")
        print("User ID: \(userId)")
        print("Preset: \(CloudinaryConfig.uploadPreset)")
        
        // Minimal params
        let params = CLDUploadRequestParams()
        
        print("\nCalling Cloudinary upload...")
        print("Endpoint: https://api.cloudinary.com/v1_1/\(CloudinaryConfig.cloudName)/image/upload")
        
        let request = cloudinary.createUploader().upload(
            data: imageData,
            uploadPreset: CloudinaryConfig.uploadPreset,
            params: params
        )
        
        request.progress { progress in
            print("Progress: \(Int(progress.fractionCompleted * 100))%")
        }
        
        request.response { result, error in
            print("\n" + "=" * 60)
            print("UPLOAD RESPONSE")
            print("=" * 60)
            
            if let error = error {
                print("❌ ERROR RECEIVED")
                print("Error: \(error.localizedDescription)")
                
                let nsError = error as NSError
                print("\nDetailed Error Info:")
                print("- Domain: \(nsError.domain)")
                print("- Code: \(nsError.code)")
                print("- Description: \(nsError.localizedDescription)")
                
                if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                    print("\nUnderlying Error:")
                    print("- Domain: \(underlyingError.domain)")
                    print("- Code: \(underlyingError.code)")
                    print("- Description: \(underlyingError.localizedDescription)")
                }
                
                print("\nFull UserInfo:")
                for (key, value) in nsError.userInfo {
                    print("- \(key): \(value)")
                }
                
                print("\n⚠️ TROUBLESHOOTING:")
                print("1. Check that preset 'donate_profile_images' exists and is Unsigned")
                print("2. Check Security settings: https://console.cloudinary.com/settings/security")
                print("3. Verify unsigned uploads are allowed on your account")
                print("=" * 60)
                
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                print("❌ No result object")
                completion(.failure(CloudinaryError.uploadFailed))
                return
            }
            
            guard let secureUrl = result.secureUrl else {
                print("❌ No secure URL in result")
                print("Result object: \(result)")
                completion(.failure(CloudinaryError.uploadFailed))
                return
            }
            
            print("✅ SUCCESS!")
            print("URL: \(secureUrl)")
            print("Public ID: \(result.publicId ?? "unknown")")
            print("Format: \(result.format ?? "unknown")")
            print("Width: \(result.width ?? 0)")
            print("Height: \(result.height ?? 0)")
            print("=" * 60)
            
            completion(.success(secureUrl))
        }
    }
    
    func deleteProfileImage(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func getProfileImageURL(userId: String, transformation: String? = nil) -> String {
        return ""
    }
    
    func getThumbnailURL(userId: String) -> String {
        return ""
    }
}

enum CloudinaryError: LocalizedError {
    case notConfigured
    case imageConversionFailed
    case fileTooLarge
    case uploadFailed
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .notConfigured: return "Cloudinary not configured"
        case .imageConversionFailed: return "Failed to convert image"
        case .fileTooLarge: return "Image too large (max 5MB)"
        case .uploadFailed: return "Upload failed"
        case .invalidURL: return "Invalid URL"
        }
    }
}

// Helper for string repetition
func *(left: String, right: Int) -> String {
    return String(repeating: left, count: right)
}
