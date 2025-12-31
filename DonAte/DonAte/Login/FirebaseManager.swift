//
//  FirebaseManager.swift
//  DonAte
//
//  FIXED: Proper Timestamp handling & Image Upload
//  Created by Claude on 30/12/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {}
    
    // MARK: - Authentication
    
    func registerUser(email: String, password: String, fullName: String, userType: UserType, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get user ID"])))
                return
            }
            
            // Create user profile
            var profile = UserProfile(uid: uid, fullName: fullName, email: email, userType: userType)
            
            // Save to Firestore
            self.saveUserProfile(profile) { result in
                switch result {
                case .success:
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get user ID"])))
                return
            }
            
            // Fetch user profile
            self.fetchUserProfile(uid: uid, completion: completion)
        }
    }
    
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        auth.currentUser?.updatePassword(to: newPassword) { error in
            completion(error)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // MARK: - Profile Management
    
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        let profileData = profile.toDictionary()
        
        db.collection("users").document(profile.uid).setData(profileData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // ✅ FIXED: Proper Timestamp handling
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  var data = document.data() else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])))
                return
            }
            
            // ✅ Convert Timestamps to Dates BEFORE JSON conversion
            if let dateOfBirthTimestamp = data["dateOfBirth"] as? Timestamp {
                data["dateOfBirth"] = dateOfBirthTimestamp.dateValue().timeIntervalSince1970
            }
            
            if let registrationTimestamp = data["registrationDate"] as? Timestamp {
                data["registrationDate"] = registrationTimestamp.dateValue().timeIntervalSince1970
            }
            
            if let lastLoginTimestamp = data["lastLogin"] as? Timestamp {
                data["lastLogin"] = lastLoginTimestamp.dateValue().timeIntervalSince1970
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                
                // Custom decoder to handle timestamps as timeIntervals
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let profile = try decoder.decode(UserProfile.self, from: jsonData)
                completion(.success(profile))
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        saveUserProfile(profile, completion: completion)
    }
    
    func updateLastLogin(uid: String) {
        db.collection("users").document(uid).updateData([
            "lastLogin": Timestamp(date: Date())
        ])
    }
    
    // MARK: - Profile Image Upload
    
    func uploadProfileImage(uid: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("profile_images/\(uid).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("📤 Starting image upload for user: \(uid)")
        
        // Upload the image
        storageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            if let error = error {
                print("❌ Upload error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            print("✅ Image uploaded to Storage successfully")
            
            // Get the download URL
            storageRef.downloadURL { [weak self] url, error in
                if let error = error {
                    print("❌ Download URL error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
                    print("❌ Failed to get download URL")
                    completion(.failure(urlError))
                    return
                }
                
                print("✅ Download URL obtained: \(downloadURL)")
                
                // Update the user's profile in Firestore with the new image URL
                self?.db.collection("users").document(uid).updateData([
                    "profileImageURL": downloadURL
                ]) { error in
                    if let error = error {
                        print("❌ Firestore update error: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("✅ Profile image URL saved to Firestore")
                        completion(.success(downloadURL))
                    }
                }
            }
        }
    }
    
    // MARK: - Impact Statistics
    
    func updateImpactStatistics(uid: String, donations: Int, mealsProvided: Int, completion: @escaping (Error?) -> Void) {
        let impactScore = (donations * 10) + (mealsProvided * 5)
        
        db.collection("users").document(uid).updateData([
            "totalDonations": FieldValue.increment(Int64(donations)),
            "totalMealsProvided": FieldValue.increment(Int64(mealsProvided)),
            "impactScore": FieldValue.increment(Int64(impactScore))
        ]) { error in
            completion(error)
        }
    }
    
    // MARK: - Current User
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }
}
