//
//  ProjectService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase

struct ProjectService {
    
    static func uploadProject(title: String, description: String, technologies: String, completon: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = [
            "owner": uid,
            "title": title,
            "technologies": technologies,
            "description": description,
        ] as [String: Any]
        
        let id = K.FStore.COLLECTION_PROJECTS.addDocument(data: data, completion: completon).documentID
        updateUserProjectAfterUpload(projectId: id)
    }
    
    static func updateProject(id: String, title: String, description: String, technologies: String, completon: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_PROJECTS.document(id).updateData([
            "owner": id,
            "title": title,
            "technologies": technologies,
            "description": description,
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
    
    static func updateUserProjectAfterUpload(projectId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-projects").document(projectId).setData([:]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            } else {
                print("Document updated succesfully!")
            }
        }
    }
    
    static func fetchProject(projctId: String, completion: @escaping(Project) -> Void) {
        K.FStore.COLLECTION_PROJECTS.document(projctId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let project = Project(projectId: snapshot.documentID, dictionary: data)
            completion(project)
        }
    }
    
    static func fetchProjects(userId: String, completion: @escaping([Project]) -> Void) {
        var projcts = [Project]()
        K.FStore.COLLECTION_USERS.document(userId).collection("user-projects").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchProject(projctId: document.documentID) { project in
                    projcts.append(project)
                    completion(projcts)
                }
            })
        }
    }

}
