//
//  GroupService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Firebase
import UIKit

struct GroupService {

    static func uploadGroup(name: String, description: String, image: UIImage, members: [User], targetMembers: Int, roomId: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        ImageUploader.uploadImage(image: image, path: "group_image") { imageUrl in
            let data = [
                "name": name,
                "description": description,
                "imageUrl": imageUrl,
                "owner": uid,
                "members": 0,
                "targetNumberOfPeople": targetMembers,
                "timestamp": Timestamp(date: Date()),
                "roomId": roomId
            ] as [String: Any]

            let id = K.FStore.COLLECTION_GROUPS.addDocument(data: data, completion: completion).documentID

            // adding group into room
            RoomService.addGroupIntoRoom(roomId: roomId, groupId: id)

            // adding members into group
            GroupService.uploadGroupMembers(groupId: id, members: members) { error in
                if let error = error {
                    print("Error adding members into group: \(error.localizedDescription)")
                } else {
                    print("Members succesfully added into group")
                }
            }
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
            completion(nil)
        }
    }

    static func deleteGroup(group: Group, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if (uid == group.owner) {
            K.FStore.COLLECTION_GROUPS.document(group.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                    return
                } else {

                    print("Document successfully removed!")
                }
                completion(nil)
            }
        } else {
            return
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

    static func fetchGroupMembers(groupId: String, completion: @escaping([User]) -> Void) {
        var members = [User]()
        K.FStore.COLLECTION_GROUPS.document(groupId).collection("group-members").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                UserService.fetchUser(userId: document.documentID) { member in
                    members.append(member)
                    completion(members)
                }
            })
        }
    }

    static func appendMemberToGroup(groupId: String, memberId: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_GROUPS.document(groupId).collection("group-members").document(memberId).setData([:]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            } else {

                let docRef = K.FStore.COLLECTION_GROUPS.document(groupId)
                docRef.updateData([
                    "members": FieldValue.increment(Int64(1))
                    ])

                completion(nil)
            }
        }
    }

    static func uploadGroupMembers(groupId: String, members: [User], completion: @escaping(Error?) -> Void) {
        members.forEach { member in
            appendMemberToGroup(groupId: groupId, memberId: member.uid) { error in
                if let error = error {
                    print("Error update after addition: \(error)")
                    return
                } else {
                    print("Document updated succesfully!")
                }
            }
        }
    }

    static func updateAfterRemovingGroup(room: Room, groupId: String, owner: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if(uid == owner) {
            updateUserRoomsAfterRemovingGorup(groupId: groupId)
            RoomService.deleteGroupFromRoom(room: room, groupId: groupId)
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
                if (document.documentID == id) {
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
