//
//  NotificationService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 03/04/2021.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(type: NotificationType, room: Room, group: Group, user: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard group.owner != currentUid else { return }
        
        
        let docRef = K.FStore.COLLECTION_NOTIFICATIONS.document(group.owner).collection("user-notification").document()
        
        var data: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "uid": currentUid,
            "type": type.rawValue,
            "roomId" : room.id,
            "roomName" : room.name,
            "roomImageUrl" : room.imageUrl,
            "groupName" : group.name,
            "groupId" : group.id,
            "groupImageUrl" : group.imageUrl,
            "profileImageUrl" : user.profileImageUrl,
            "userName" : user.fullname,
            "id" : docRef.documentID
        ]

        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map({ Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
    
    static func deleteNotitfication(notificationId: String, completion:@escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FStore.COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").document(notificationId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
                return
            } else {
                print("Document successfully removed!")
                completion(nil)
            }
        }
    }
    
}
