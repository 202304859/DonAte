//
//  FirebaseManager.swift
//  DonAte
//
//  ✅ COMPLETE: Added organization data methods
//  ✅ FIXED: All upload methods use Cloudinary
//  Updated: January 2, 2026
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    
    // MARK: - Singleton
    static let shared = FirebaseManager()
    
    // MARK: - Properties
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    private init() {}
    
    // MARK: - Authentication
    
    /// Login user with email and password
    func loginUser(email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                let error = NSError(domain: "FirebaseManager", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to get user ID"
                ])
                completion(.failure(error))
                return
            }
            
            // Fetch user profile
            self?.fetchUserProfile(uid: uid, completion: completion)
        }
    }
    
    /// Register new user
    func registerUser(email: String, password: String, fullName: String, userType: UserType, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                let error = NSError(domain: "FirebaseManager", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to get user ID"
                ])
                completion(.failure(error))
                return
            }
            
            // Create user profile
            let profile = UserProfile(uid: uid, fullName: fullName, email: email, userType: userType)
            
            // Save to Firestore
            self?.db.collection("users").document(uid).setData(profile.toDictionary()) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(profile))
                }
            }
        }
    }
    
    /// Reset password
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email, completion: completion)
    }
    
    /// Update last login time
    func updateLastLogin(uid: String) {
        db.collection("users").document(uid).updateData([
            "lastLogin": FieldValue.serverTimestamp()
        ])
    }
    
    /// Change user password
    func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        currentUser?.updatePassword(to: newPassword, completion: completion)
    }
    
    /// Logout user
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    // MARK: - Upload Profile Image (Using Cloudinary)
    
    /// Upload profile image to Cloudinary and save URL to Firestore
    func uploadProfileImage(uid: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert data to UIImage
        guard let image = UIImage(data: imageData) else {
            let error = NSError(domain: "FirebaseManager", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to convert image data"
            ])
            completion(.failure(error))
            return
        }
        
        // Use the UIImage method
        uploadProfileImage(uid: uid, image: image, completion: completion)
    }
    
    /// Upload profile image using UIImage directly
    func uploadProfileImage(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        print("📤 Uploading profile image via Cloudinary...")
        
        CloudinaryManager.shared.uploadProfileImage(image: image, userId: uid) { [weak self] result in
            switch result {
            case .success(let imageURL):
                print("✅ Cloudinary upload successful: \(imageURL)")
                
                // Save URL to Firestore
                self?.updateProfileImageURL(uid: uid, imageURL: imageURL) { firestoreResult in
                    switch firestoreResult {
                    case .success:
                        print("✅ Profile image URL saved to Firestore")
                        completion(.success(imageURL))
                    case .failure(let error):
                        print("⚠️ Cloudinary upload succeeded but Firestore update failed: \(error.localizedDescription)")
                        // Still return success since image is uploaded
                        completion(.success(imageURL))
                    }
                }
                
            case .failure(let error):
                print("❌ Cloudinary upload failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update Profile Image URL
    
    private func updateProfileImageURL(uid: String, imageURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "profileImageURL": imageURL,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - User Profile Management
    
    /// Fetch user profile from Firestore
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                let error = NSError(domain: "FirebaseManager", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "No user data found"
                ])
                completion(.failure(error))
                return
            }
            
            do {
                let profile = try self.parseUserProfile(from: data, uid: uid)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Update user profile in Firestore
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        // Start with required fields only
        var data: [String: Any] = [
            "fullName": profile.fullName,
            "email": profile.email,
            "userType": profile.userType.rawValue,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        // Add optional fields only if they exist and are not empty
        if let phoneNumber = profile.phoneNumber, !phoneNumber.isEmpty {
            data["phoneNumber"] = phoneNumber
        }
        
        if let location = profile.location, !location.isEmpty {
            data["location"] = location
        }
        
        if let dateOfBirth = profile.dateOfBirth {
            data["dateOfBirth"] = Timestamp(date: dateOfBirth)
        }
        
        if let profileImageURL = profile.profileImageURL, !profileImageURL.isEmpty {
            data["profileImageURL"] = profileImageURL
        }
        
        // Add diet preferences and allergies
        data["dietPreferences"] = profile.dietPreferences.map { $0.rawValue }
        data["allergies"] = profile.allergies
        
        db.collection("users").document(profile.uid).setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Organization Management (For Collectors)
    
    /// Save organization data to Firestore
    func saveOrganizationData(uid: String, organizationData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        var data = organizationData
        data["uid"] = uid
        data["createdAt"] = FieldValue.serverTimestamp()
        data["updatedAt"] = FieldValue.serverTimestamp()
        data["isVerified"] = false // Default to not verified
        
        db.collection("organizations").document(uid).setData(data, merge: true) { error in
            if let error = error {
                print("❌ Error saving organization data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ Organization data saved successfully")
                completion(.success(()))
            }
        }
    }
    
    /// Fetch organization data from Firestore
    func fetchOrganizationData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("organizations").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                let error = NSError(domain: "FirebaseManager", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "No organization data found"
                ])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
    }
    
    /// Upload organization verification document using Cloudinary
    func uploadVerificationDocument(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        print("📤 Uploading verification document via Cloudinary...")
        
        CloudinaryManager.shared.uploadProfileImage(image: image, userId: "\(uid)_verification") { [weak self] result in
            switch result {
            case .success(let imageURL):
                print("✅ Verification document uploaded: \(imageURL)")
                
                // Save URL to organization document
                self?.db.collection("organizations").document(uid).updateData([
                    "verificationDocumentURL": imageURL,
                    "verificationUploadedAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        print("⚠️ Document uploaded but Firestore update failed: \(error.localizedDescription)")
                        completion(.success(imageURL)) // Still return success
                    } else {
                        print("✅ Verification document URL saved to Firestore")
                        completion(.success(imageURL))
                    }
                }
                
            case .failure(let error):
                print("❌ Verification document upload failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func parseUserProfile(from data: [String: Any], uid: String) throws -> UserProfile {
        // Required fields
        guard let fullName = data["fullName"] as? String,
              let email = data["email"] as? String else {
            throw NSError(domain: "FirebaseManager", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Missing required profile fields (fullName or email)"
            ])
        }
        
        // Parse userType (default to donor if not found)
        let userTypeString = data["userType"] as? String ?? "Donor"
        let userType = UserType(rawValue: userTypeString) ?? .donor
        
        // Optional fields - safe to be nil
        let phoneNumber = data["phoneNumber"] as? String
        let location = data["location"] as? String
        let profileImageURL = data["profileImageURL"] as? String
        
        var dateOfBirth: Date?
        if let timestamp = data["dateOfBirth"] as? Timestamp {
            dateOfBirth = timestamp.dateValue()
        }
        
        // Parse diet preferences
        var dietPreferences: [DietPreference] = []
        if let dietPrefs = data["dietPreferences"] as? [String] {
            dietPreferences = dietPrefs.compactMap { DietPreference(rawValue: $0) }
        }
        
        // Parse allergies
        let allergies = data["allergies"] as? [String] ?? []
        
        // Create UserProfile (using the init that requires userType)
        var profile = UserProfile(uid: uid, fullName: fullName, email: email, userType: userType)
        
        // Set optional values
        profile.phoneNumber = phoneNumber
        profile.location = location
        profile.dateOfBirth = dateOfBirth
        profile.profileImageURL = profileImageURL
        profile.dietPreferences = dietPreferences
        profile.allergies = allergies
        
        // Parse additional fields if they exist
        if let verificationStatus = data["verificationStatus"] as? Bool {
            profile.verificationStatus = verificationStatus
        }
        if let totalDonations = data["totalDonations"] as? Int {
            profile.totalDonations = totalDonations
        }
        if let totalMealsProvided = data["totalMealsProvided"] as? Int {
            profile.totalMealsProvided = totalMealsProvided
        }
        if let impactScore = data["impactScore"] as? Int {
            profile.impactScore = impactScore
        }
        
        return profile
    }
}
