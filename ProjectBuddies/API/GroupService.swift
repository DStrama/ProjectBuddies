//
//  GroupService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase
import UIKit

struct GroupService {
    
    static func uploadGroup(name: String, description: String, image: UIImage, members: Int, targetMembers: Int, roomId: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image, path: "group_image") { imageUrl in
            let data = [
                "name" : name,
                "description" : description,
                "imageUrl" : imageUrl,
                "owner" : uid,
                "members" : members,
                "targetNumberOfPeople" : targetMembers,
                "timestamp": Timestamp(date: Date()),
                "roomId": roomId
            ] as [String : Any]
            
            let id = K.FStore.COLLECTION_GROUPS.addDocument(data: data, completion: completion).documentID
//            updateUserGroupsAfterAddition(groupId: id)
            RoomService.addGroupIntoRoom(roomId: roomId, groupId: id)
        }
    }
    
//    static func updateUserGroupsAfterAddition(groupId: String) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        K.FStore.COLLECTION_USERS.document(uid).collection("user-groups").document(groupId).setData([:]) { error in
//            if let error = error {
//                print("Error update after addition: \(error)")
//                return
//            } else {
//                print("Document updated succesfully!")
//            }
//        }
//    }
    
    static func deleteGroup(id: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_GROUPS.document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                
                print("Document successfully removed!")
            }
        }
    }
    
    static func fetchGroups(roomId: String, completion: @escaping([Group]) -> Void) {
        var groups = [Group]()
        
        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-groups").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchGroup(groupId: document.documentID) { group in
                    groups.append(group)
                    completion(groups)
                }
            })
        }
    }
    
    static func fetchGroup(groupId: String, completion: @escaping(Group) -> Void) {
        K.FStore.COLLECTION_GROUPS.document(groupId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let group = Group(groupId: snapshot.documentID, dictionary: data)
            completion(group)
        }
    }
    
    static func updateAfterRemovingGroup(roomId: String, groupId: String, owner: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if(uid == owner) {
            updateUserRoomsAfterRemovingGorup(groupId: groupId)
            RoomService.deleteGroupFromRoom(roomId: roomId, groupId: groupId)
        }
    }
    
    static func updateUserRoomsAfterRemovingGorup(groupId: String) {
        deleteGroup(id: groupId) { (error) in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }

        deleteInUserGorupsCollectionGorup(id: groupId) { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }
    }
    
    static func deleteInUserGorupsCollectionGorup(id: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-groups").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                if ( document.documentID == id ) {
                    K.FStore.COLLECTION_USERS.document(uid).collection("user-groups").document(id).delete { error in
                        if let error = error {
                            print("Error removing room in user-rooms collection: \(error)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            })
        }
    }
}
