//
//  AuthService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 15/03/2021.
//

import Firebase
import FirebaseDatabase
import GoogleSignIn

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    
    private let database = Database.database().reference()
    
    static func registerUser(withCredenctial credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credentials.profileImage, path: "profile_image") { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "uid": uid,
                                           "fullname": credentials.fullname,
                                           "profileImageUrl": imageUrl,
                                           "hobbies": [],
                                           "softskills": [],
                                           "aboutme": [],
                                           "hardskills": [],
                ]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func logUserIn(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func signupWithGoogle(user: GIDGoogleUser, credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("DEBUG: Failed to log in with google \(error.localizedDescription)")
                return
            }
            
        }
    }
    
    static func singoutUser(completion: @escaping(Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
    }
}
