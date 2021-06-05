//
//  Message.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import Firebase
import MessageKit

struct Message {
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var dictionary: [String: Any] {
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName": senderName,
        ]
    }
    
    init(id: String, content: String, created: Timestamp, senderID: String, senderName: String) {
        self.id = id
        self.content = content
        self.created = created
        self.senderID = senderID
        self.content = content
        self.senderName = senderName
    }
}

extension Message {
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
        let content = dictionary["content"] as? String,
        let created = dictionary["created"] as? Timestamp,
        let senderID = dictionary["senderID"] as? String,
        let senderName = dictionary["senderName"] as? String
        else { return nil }
        
        self.id = id
        self.content = content
        self.created = created
        self.senderID = senderID
        self.content = content
        self.senderName = senderName
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: senderName)
    }

    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}


