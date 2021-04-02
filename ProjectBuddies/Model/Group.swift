//
//  Group.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 06/03/2021.
//

import Firebase

struct Group {
    let id: String
    let owner: String
    var name: String
    var description: String
    var members: Int
    let groupId: String
    let timestamp: Timestamp
    let imageUrl: String
    var targetNumberOfPeople: Int
    
    init(groupId: String, dictionary: [String: Any]) {
        self.id = groupId
        self.name = dictionary["name"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.owner = dictionary["owner"] as? String ?? ""
        self.members = dictionary["members"] as? Int ?? 0
        self.groupId = dictionary["groupId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.targetNumberOfPeople = dictionary["targetNumberOfPeople"] as? Int ?? 0
    }
}
