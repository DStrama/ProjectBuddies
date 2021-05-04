//
//  Room.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import Firebase

struct Room {
    let id: String
    let owner: String
    var members: Int
    var groups: Int
    var name: String
    let imageUrl: String
    let key : String
    let timestamp: Timestamp
    
    init(roomId: String, dictionary: [String: Any]) {
        self.id = roomId
        self.owner = dictionary["owner"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.key = dictionary["key"] as? String ?? ""
        self.members = dictionary["members"] as? Int ?? 0
        self.groups = dictionary["groups"] as? Int ?? 0
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
