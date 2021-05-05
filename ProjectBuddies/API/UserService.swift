//
//  UserService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 16/03/2021.
//

import Firebase

struct UserService {
    static func fetchCurrentUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).getDocument { (snapchot, error) in
            guard let dictionary = snapchot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUser(userId: String, completion: @escaping(User) -> Void) {
        K.FStore.COLLECTION_USERS.document(userId).getDocument { (snapchot, error) in
            guard let dictionary = snapchot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        K.FStore.COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchUser(userId: document.documentID) { user in
                    users.append(user)
                    completion(users)
                }
            })
        }
    }
    
    static func updateUser(field: String, value: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).updateData([field : value]) { error in
            if let error = error {
                print("Error updated document: \(error)")
            } else {
                print("Document successfully updated!")
                completion(nil)
            }
        }
    }
    
    static func appendFieldToUser(field: String, value: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).updateData([field: FieldValue.arrayUnion([value])]) { error in
            if let error = error {
                print("Error updated document: \(error)")
            } else {
                print("Document successfully appended!")
                completion(nil)
            }
        }
    }
    
    static func updateUserImage(image: UIImage, completion: @escaping(String, Error?) -> Void) {
        ImageUploader.uploadImage(image: image, path: "profile_image") { imageUrl in
            UserService.updateUser(field: "profileImageUrl", value: imageUrl) { error in
                if let error = error {
                    print("Error updated document: \(error)")
                }
                completion(imageUrl, nil)
            }
        }
        
    }
    
    static func sendPasswordResetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error reseting password: \(error)")
            }
        }
    }
    
    static func updateUserFiledsAfterOnbording(name: String, photo: UIImage, bio: String, completion: @escaping(Error?) -> Void) {
        UserService.updateUser(field: "fullname", value: name) { error in
            if let error = error {
                print("Error updated document: \(error)")
            } else {
                print("Document successfully updated!")
                completion(nil)
            }
        }
        UserService.updateUser(field: "aboutme", value: bio) { error in
            if let error = error {
                print("Error updated document: \(error)")
            } else {
                print("Document successfully updated!")
                completion(nil)
            }
        }

        UserService.updateUserImage(image: photo) { img, error in
            if let error = error {
                print("Error updated document: \(error)")
            } else {
                print("Document successfully updated!")
                completion(nil)
            }
        }
    }
}
