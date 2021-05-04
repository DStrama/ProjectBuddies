//
//  MesssageService.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 26/04/2021.
//

import Firebase

struct MessageService {
    
    static func uploadMessage(content: String, type: String, userName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var data: [String: Any] = [
            "uid" : uid,
            "content" : content,
            "isRead" : false,
            "type" : type,
            "timestamp": Timestamp(date: Date()),
            "userName" : userName
        ]
    }
}
