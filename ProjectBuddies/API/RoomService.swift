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
                "name" : name,
                "imageUrl" : imageUrl,
                "key" : key,
                "owner" : uid,
                "members" : [uid],
                "timestamp": Timestamp(date: Date())
            ] as [String : Any]
            
            K.FStore.COLLECTION_ROOMS.addDocument(data: data, completion: completion)
        }
    }
    
    static func deleteRoom(id: String, completion: @escaping(Error?) -> Void) {
        K.FStore.COLLECTION_ROOMS.document(id).delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func fetchRooms(completion: @escaping([Room]) -> Void) {
        K.FStore.COLLECTION_ROOMS.order(by: "timestamp", descending: true).getDocuments { (snapchot, error) in
            guard let documents = snapchot?.documents else { return }
            let rooms = documents.map({ Room(roomId: $0.documentID ,dictionary: $0.data())})
            completion(rooms)
        }
    }
    
}
