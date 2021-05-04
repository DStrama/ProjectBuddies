//
//  RoomService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 15/03/2021.
//

import UIKit
import Firebase

struct RoomService {

    static func uploadRoom(name: String, image: UIImage, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let key = NSUUID().uuidString

        ImageUploader.uploadImage(image: image, path: "room_image") { imageUrl in
            let data = [
                "name": name,
                "imageUrl": imageUrl,
                "key": key,
                "owner": uid,
                "timestamp": Timestamp(date: Date()),
                "members": 1,
                "groups": 0
            ] as [String: Any]

            let id = K.FStore.COLLECTION_ROOMS.addDocument(data: data, completion: completion).documentID

            updateUserRoomsAfterAddition(roomId: id)

            K.FStore.COLLECTION_ROOMS.document(id).collection("room-members").document(uid).setData([:]) { error in
                if let error = error {
                    print("Error update after addition: \(error)")
                    return
                } else {
                    print("Document updated succesfully!")
                }
            }
        }
    }

    static func deleteRoom(id: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    static func fetchRooms(completion: @escaping([Room]) -> Void) {
        K.FStore.COLLECTION_ROOMS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            let rooms = documents.map({ Room(roomId: $0.documentID, dictionary: $0.data()) })
            completion(rooms)
        }
    }

    static func fetchRoom(roomId: String, completion: @escaping(Room) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(roomId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let room = Room(roomId: snapshot.documentID, dictionary: data)
            completion(room)
        }
    }

    static func fetchUserRooms(completion: @escaping([Room]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var rooms = [Room]()

        K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchRoom(roomId: document.documentID) { room in
                    rooms.append(room)
                    completion(rooms)
                }
            })
        }
    }

    static func fetchRoomMembers(roomId: String, completion: @escaping([User]) -> Void) {
        var members = [User]()
        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-members").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                UserService.fetchUser(userId: document.documentID) { member in
                    members.append(member)
                    completion(members)
                }
            })
        }
    }

    static func updateRoomMembersAfterAddition(room: Room) {
        let ref = K.FStore.COLLECTION_ROOMS.document(room.id)
        ref.updateData(["members": room.members + 1])
    }

    static func updateRoomMembersAfterRemoving(room: Room) {
        let ref = K.FStore.COLLECTION_ROOMS.document(room.id)
        ref.updateData(["members": room.members - 1])
    }

    static func updateRoomGroupsAfterAddition(room: Room) {
        let ref = K.FStore.COLLECTION_ROOMS.document(room.id)
        ref.updateData(["groups": room.groups + 1])
    }

    static func updateRoomGoupsAfterRemoving(room: Room) {
        let ref = K.FStore.COLLECTION_ROOMS.document(room.id)
        ref.updateData(["groups": room.groups - 1])
    }

    static func updateUserRoomsAfterAddition(roomId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").document(roomId).setData([:]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            } else {
                print("Document updated succesfully!")
            }
        }
    }

    static func deleteInUserRoomsCollectionRoom(id: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                if (document.documentID == id) {
                    K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").document(id).delete { error in
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

    static func updateAfterRemovingRoom(room: Room) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if(uid == room.owner) {
            updateUserRoomsAfterRemovingRoom(room: room)
        } else {
            updateUserRoomsAfterLeavingRoom(room: room)
        }
    }

    static func updateUserRoomsAfterRemovingRoom(room: Room) {

        deleteRoom(id: room.id) { (error) in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }

        deleteInUserRoomsCollectionRoom(id: room.id) { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }

        deleteRoomGroups(room: room) { error in
            if let error = error {
                print("Error removing groups from room: \(error)")
                return
            }
        }

        deleteRoomMembers(roomId: room.id) { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            }
        }
    }

    static func updateUserRoomsAfterLeavingRoom(room: Room) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").document(room.id).delete { error in
            if let error = error {
                print("Error removing room id from user rooms collections: \(error)")
            } else {
                updateRoomMembersAfterRemoving(room: room)
                deleteMemberFromRoomMembers(roomId: room.id, uid: uid) { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                        return
                    }
                }
                print("Document successfully removed!")
            }
        }
    }

    static func joinRoom(key: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        K.FStore.COLLECTION_ROOMS.document(key).collection("room-members").getDocuments { snapshot, error in
            let filtered = snapshot?.documents.filter({ $0.documentID == uid })
            if filtered!.count > 0 {
                //todo: show that user already belong to this room
                print("You already belong to this room.")
                completion(nil)
            } else {
                let docRef = K.FStore.COLLECTION_ROOMS.document(key)
                docRef.getDocument { (document, error) in
                    if let document = document {
                        if document.exists {
                            updateUserRoomsAfterAddition(roomId: key)
                            fetchRoom(roomId: key) { room in
                                updateRoomMembersAfterAddition(room: room)
                            }
                            K.FStore.COLLECTION_ROOMS.document(key).collection("room-members").document(uid).setData([:]) { error in
                                if let error = error {
                                    print("Error update after addition: \(error)")
                                    return
                                } else {
                                    print("Document updated succesfully!")
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                    completion(nil)
                }
            }
        }
    }

    static func addGroupIntoRoom(roomId: String, groupId: String) {
        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-groups").document(groupId).setData([:]) { error in
            if let error = error {
                print("Error update after addition: \(error)")
                return
            }
            fetchRoom(roomId: roomId) { room in
                updateRoomGroupsAfterAddition(room: room)
            }
        }
    }

    static func deleteGroupFromRoom(room: Room, groupId: String) {
        K.FStore.COLLECTION_ROOMS.document(room.id).collection("room-groups").document(groupId).delete()
        updateRoomGoupsAfterRemoving(room: room)
    }

    static func deleteRoomGroups(room: Room, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(room.id).collection("room-groups").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                K.FStore.COLLECTION_ROOMS.document(room.id).collection("room-groups").document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting members after room was delated: \(error)")
                        return
                    }

                    updateRoomGoupsAfterRemoving(room: room)
                }
            })
        }
    }

    static func deleteMemberFromRoomMembers(roomId: String, uid: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-members").document(uid).delete()
    }

    static func deleteRoomMembers(roomId: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-members").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-members").document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting members after room was delated: \(error)")
                        return
                    }
                }
            })
        }
    }

//    static func updateRoomMembersAfterRemoving(roomId: String) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        K.FStore.COLLECTION_ROOMS.document(roomId).collection("room-members").getDocuments { snapshot, error in
//            snapshot?.documents.forEach({ document in
//                if ( document.documentID == uid ) {
//                    K.FStore.COLLECTION_USERS.document(roomId).collection("room-members").document(uid).delete { error in
//                        if let error = error {
//                            print("Error removing room in user-rooms collection: \(error)")
//                        } else {
//                            print("Document successfully removed!")
//                        }
//                    }
//                }
//            })
//        }
//
//    }
//
//    static func updateUserRoomsAfterAddition(roomId: String) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        K.FStore.COLLECTION_USERS.document(uid).collection("user-rooms").document(roomId).setData([:]) { error in
//            if let error = error {
//                print("Error update after addition: \(error)")
//                return
//            } else {
//                print("Document updated succesfully!")
//            }
//        }
//    }


}

