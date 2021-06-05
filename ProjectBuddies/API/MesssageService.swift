//
//  MesssageService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 26/04/2021.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct MessageService {
    
    static func uploadMessage(docRef: DocumentReference, message: Message, completion: @escaping(Error?) -> Void) {

        let data: [String: Any] = [
            "id" : message.id,
            "content" : message.content,
            "created" : message.created,
            "senderID" : message.senderID,
            "senderName": message.senderName,
        ]
        
        docRef.collection("thread").addDocument(data: data) { error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            } else {
                completion(nil)
            }
        }
        
    }
    
    static func fetchConversation(userTwoUID: String, completion: @escaping([Message]?,DocumentReference?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = K.FStore.COLLECTION_CHATS.whereField("users", arrayContains: uid)
        var docRef: DocumentReference?
        
        db.getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                if queryCount >= 1 {
                    snapshot?.documents.forEach({ document in
                        let chat = Chat(id: document.documentID, dictionary: document.data())
                        if(chat?.users.contains(userTwoUID))! {
                            docRef = document.reference
                            document.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                                if let error = error {
                                    print("DEBUG: Error \(error)")
                                } else {
                                    var messeges: [Message] = []
                                    snapshot!.documents.forEach({ message in
                                        messeges.append(Message(dictionary: message.data())!)
                                    })
                                    completion(messeges, docRef)
                                }
                            }
                        } else {
                            return
                        }
                    })
                } else if queryCount == 0 {
                    return completion(nil, nil)
                } else {
                    print("error")
                }
            }
        }
    }
    
    static func fetchAllUserConversations(completion: @escaping([Chat?]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        K.FStore.COLLECTION_CHATS.whereField("users", arrayContains: uid).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let conversations = documents.map({ Chat(id: $0.documentID, dictionary: $0.data()) })
            completion(conversations)
        }
    }
    
    static func createNewChat(userTwoID: String, completion: @escaping(DocumentReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let users = [uid, userTwoID]
        
        let data: [String: Any] = [
            "users": users
        ]
        
        let doc = K.FStore.COLLECTION_CHATS.addDocument(data: data) { error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            }
        }
        completion(doc)
    }
    
    static func getCurrentSender(user: User) -> SenderType {
        let uid = Auth.auth().currentUser?.uid
        let displayName = user.fullname
        return Sender(senderId: uid!, displayName: displayName)
    }
}
