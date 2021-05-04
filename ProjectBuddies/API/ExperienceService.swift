//
//  ExperienceService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct ExperienceService {
    
    static func updateExperience(id: String, title: String, company: String, description: String, completon: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_EXPERIENCES.document(id).updateData([
            "title" : title,
            "company" : company,
            "description" : description,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            } else {
                print("Document updated succesfully!")
                completon(nil)
            }
        }
    }
    
    static func uploadExperience(title: String, company: String, description: String, completon: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = [
            "owner": uid,
            "title": title,
            "company": company,
            "description": description,
        ] as [String: Any]
        
        let id = K.FStore.COLLECTION_EXPERIENCES.addDocument(data: data, completion: completon).documentID
        updateUserExperienceAfterUpload(experienceId: id)
    }
    
    static func updateUserExperienceAfterUpload(experienceId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-experience").document(experienceId).setData([:]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            } else {
                print("Document updated succesfully!")
            }
        }
    }
    
    static func fetchExperience(experienceId: String, completion: @escaping(Experience) -> Void) {
        K.FStore.COLLECTION_EXPERIENCES.document(experienceId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let experience = Experience(experienceId: snapshot.documentID, dictionary: data)
            completion(experience)
        }
    }
    
    static func fetchExperiences(userId: String, completion: @escaping([Experience]) -> Void) {
        var experiences = [Experience]()
        K.FStore.COLLECTION_USERS.document(userId).collection("user-experience").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchExperience(experienceId: document.documentID) { experience in
                    experiences.append(experience)
                    completion(experiences)
                }
            })
        }
    }
    
    static func removeExperience(experienceId: String,  completon: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_EXPERIENCES.document(experienceId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func deleteInUserExperienceCollectionExperience(experienceId: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-experience").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                if ( document.documentID == experienceId ) {
                    K.FStore.COLLECTION_USERS.document(uid).collection("user-experience").document(experienceId).delete { error in
                        if let error = error {
                            print("Error removing experience in user-experience collection: \(error)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            })
        }
    }
    
    static func updateUserRoomsAfterRemovingRoom(experienceId: String) {
        removeExperience(experienceId: experienceId) { (error) in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }

        deleteInUserExperienceCollectionExperience(experienceId: experienceId) { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }
    }
    
}
